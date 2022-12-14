# Notes

These are for me to jot down some things I'm learning as I reference https://www.ktorm.org and figuring out how to implement something similar in Crystal.

## Why?

What are the motivating reasons for making another ORM?

- Avram connects to Lucky params and the view layer which leads the standard way of writing code using Lucky to be very flat
  - No talk about repository layers or a layout around domains
- With the way Avram Operations work, it's meant to encompass all of your code instead of used by your code for database operations
- Other ORMs try to copy dynamic language ORMS (ActiveRecord, Ecto) and have limitations
- I want POCO models that don't carry alot of baggage and are trivial to make as many as necessary
  - With the way the current ORMs work, there's a whole lat that is connected to models
  - it's pretty much 1 to 1 model to table and it's not possible to do things like selecting only a subset of fields, joining other tables, etc.

## Other

### Storing the result set results

Because the interface is chainable, the result set needs to be pulled out and cached so that it can be iterated over as many times as needed

### Visitor Pattern

ktorm has a visitor pattern for turning sql expressions into a sql statement.
Except it still does what the visitor pattern is trying to avoid which is having conditionals for every type being visited.
https://github.com/kotlin-orm/ktorm/blob/85647c01ed6504ea7a13a9e4ee4b50377dfd8e6a/ktorm-core/src/main/kotlin/org/ktorm/expression/SqlExpressionVisitor.kt#L43-L56
I've long been confused why the objects being visited need an "accept" method when they all call the same thing.
I even made sure that you could just have overloads of a "visit" method on the visitor and pass in the classes that way and it works fine.
The one reason I found for why you would still want to do the "accept" method still is to restrict the types being visited to one base class.
So you can have a visitor with a visit overload for an array and a struct, but if you limit the entrance to the visitor patter to an accept method on a shared interface then you limit it to the classes that implement the interface.
In this case, I will limit it to classes that implement `SqlExpression` by putting the "accept" method requirement there.
I did verify that it still works with the "accept" method implemented in `SqlExpression` so I don't have to have the same method implemented in every subclass.

All of this to say, I want to use the visitor pattern, but I'm going to implement it correctly whereas I don't think ktorm did.

## Generics

Frustrating trying to work with generics in this library.
Had to add the BaseColumn and BaseColumnExpression classes to cope with the need for arrays of these things.
**NOTE** The code works as it is right now with the `abstract def as_expression` commented out in `Focus::BaseColumn` which seems... broken?

One thing I just realized with Ktorm's generics usage is that Kotlin is able to conditionally add methods to an object based on generics

```kotlin
public operator fun ColumnDeclaring<Boolean>.not(): UnaryExpression<Boolean> {
    return UnaryExpression(UnaryExpressionType.NOT, asExpression(), BooleanSqlType)
}
```

This means that only boolean columns (`ColumnDeclaring` is a bit more than just columns but w/e) have access to the `not` method.
I don't think there is an equivalent in Crystal

UPDATE: After talking about it in the Discord, I found a hack solution for this.

```crystal
def not : UnaryExpression(Bool)
  {% raise "#{@type.name}##{@def.name} may only be used with Bool columns" %}
  UnaryExpression.new(
    Focus::UnaryExpressionType::NOT,
    operand: as_expression,
    sql_type: Bool
  )
end
```

The macro `raise` call means that it fails at compile time if you call the method and the generic isn't `Bool`.
I'm not going to do it right now because there's so much more important work to do right now.
This only keeps devs from building incorrect sql, so we're going to go without this safety feature until later on.

### Query results by field

Traced back java's postgres library and java's sqlite library.
The sqlite one seems to do some sort of interaction with the native library to get a column name from the result set.
Postgres, on the other hand, passes the fields from the query to the result set.
I think the postgres implementation is exactly what I was thinking I could do, so I'm glad to find an example.

Side note... tracing java libraries (and especially ones as complicated as SQL integrations) is ridiculously difficult.

I was happy with the current implementation of how you can get results by passing in the field...
that is, until I tried to implement `SELECT * FROM users`. When you provide a way to select "*" then you aren't passed any of the column information.
I don't really want to trace java code right now, so I'm making this note and removing that functionality.

I was wrong about how the Java Postgres library gets the field name.
https://github.com/pgjdbc/pgjdbc/blob/d5ed52ef391670e83ae5265af2f7301c615ce4ca/pgjdbc/src/main/java/org/postgresql/core/v3/QueryExecutorImpl.java#L2619-L2644

How do they do it? Don't know

I'm...so...dumb. After finding out about ^ I looked at crystal-pg and crystal-sqlite and they both implemented stuff around column name... so I look at crystal-db. Right in front of my face the whole time is the column_name method.

Still a problem though. If I join two tables that have overlapping column names, there's no way to determine the difference with the way things are right now.
Looking into postgres, they issue a separate query. https://github.com/pgjdbc/pgjdbc/blob/d5ed52ef391670e83ae5265af2f7301c615ce4ca/pgjdbc/src/main/java/org/postgresql/jdbc/PgResultSetMetaData.java#L187
What should I do?
The reason it's not a problem for anyone else is that they don't serialize joins often, and the ordering of how you extract data from the result set matters.
https://github.com/crystal-lang/crystal-db/issues/175

## Table Macro

I'm really hoping this will be the only macro and I plan to document exactly what the table looks like so that people aren't scared of the macro or confused.
They wouldn't even have to use it if they don't want to.

## Entity Binding

I have not implemented this yet as I was focusing solely on the query building.

One thing I don't like about Ktorm is how it implemented entity binding https://www.ktorm.org/en/entities-and-column-binding.html

It goes against my stated goal which is to not tie the database table down to one singular model.
Ktorm has you define the entity on the table which does exactly that.

Looked into this more, seems like we don't need the entity sequence as much as I though.
Stuff around grouping might be wanted, but the main thing was getting an iterable list of the entities and getting just one

## Ktorm Blocks

For a long time, I've wondered why a lot of methods take in a block when it always seemed like it could just take in one argument instead.
The blocks always pass in the table, but all the doc examples I've seen never use it.
In my code I didn't add block overloads, `#where` is the best example.
I finally realized why you would want the block, though.
With a block you could have helper functions that don't care what the table is, but uses methods that are on all tables.
The best example I can come up with is pagination. I can't do it without telling the pagination which table to use.
I'm sure there's alternatives to the block, so I'm not sure I want to add in the block stuff right now anyways.
