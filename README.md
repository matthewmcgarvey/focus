# Focus

SQL query builder for multiple databases. Heavily inspired by Kotlin's [Ktorm](https://www.ktorm.org).
Do you want to learn an ORM or do you want to be able to focus?

Not at all ready for real use. (There's not even any tests, so don't be crazy and try to use it for real.)

## Goals

### Create an easy to understand library

I don't want this library to take 10 months to feel like you know how to do everything.
I want it to be made in a way that's not only easy to use, but easy to dig into internally.
That means two things:

1. This will be a clean, well documented DSL
2. There will be minimal macro usages

I want to avoid macro usages because, while they can make code simpler to write, it can cause confusion for maintainers and developers when they run into bugs.
By trying to avoid macros, I also have to think about how I can use regular Crystal to make a pleasant API rather than fall back to macros.
As of right now, I only have one macro which is `Stealth::Table.column`. It's only used when defining tables and I believe it's necessary to avoid users immediately running into hand cramps when defining tables.
Maybe one day this library could have no macros?

### Separate data models from database tables

This will probably be the most unusual goal of this project.
The vast majority of ORMs have you define your data model and equate that to a table in the database.
When you create a `User` model, it wraps the `users` table in the database and that class is how you fetch and manipulate data.
So why change that?
Well, from my experience in Crystal over the past few years, maintaining that style fundamentally limits the database queries that can be safely constructed (or else they provide a backdoor way to do it that feels like you're subverting the whole point of the ORM) and places quite a burden on the maintainers of the project to add increasing complexity to manage the codebase and add more and more features.
We've spent enough time trying to copy ActiveRecord, and it's just not going to be possible to provide the same flexibility that it does.
So I'm trying a different path. One where you define your table completely separately from your data models. The table is used to build queries and the results can be parsed just as they are or bound to a data model.
This way, you can have as many data models as you want connected to the same table, you can build much more customized SQL queries, and the internals of the library are much simpler to understand.

### Work with multiple database types

I don't want to limit this library to just PostgreSQL. I want developers to be able to fully use different databases even within the same project.
By "fully use" I do mean that I want to provide accessible DSLs or extension points to use all the features of a particular database (like jsonb in PostgreSQL).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     focus:
       github: matthewmcgarvey/focus
   ```

2. Run `shards install`

## Usage

### Define a table

Tables are where we connect Crystal code to the database tables.
It's important to understand that these are not our data models.
They are used to build queries.

```crystal
class UsersTable < Focus::Table
  @table_name = "users"

  column id : Int64
  column name : String
  column role : String
end

Users = UsersTable.new
```

We define the table `UsersTable` with the table name and the columns.
We then create an instance and assign it to `Users` for a nice API.

### Make a query

```crystal
Users.select(Users.id)
  .where(Users.role.eq("admin"))
  .query_all(database, Int64)
```

### Bind rows to Crystal objects

Focus cleanly integrates with `DB::Serializable`.

```crystal
struct User
  include DB::Serializable

  property id : Int64
  property name : String
  property role : String
end

users = Users.select.query_all(database, as: User)
```

### Insert data

```crystal
Users.insert(Users.name, Users.role)
  .values("bobby", "users")
  .exec(database)
```

### Update data

```crystal
Users.update
  .set(Users.role, "admin")
  .where(Users.name.eq("bobby"))
  .exec(database)
```

## Development

TODO: Write development instructions here

## Rewrite

- Values table
- Dialect hooks/changes
- SELECT FOR UPDATE
- Functions (like timestamp)
- Rework table classes
- Table class generator

## TODO

- Int32 vs Int64 primary keys
  - Error when using Int32 keys is very confusing, solution is to switch to Int64 but you wouldn't know it
- Write good tests
- Custom data types (i.e. postgis)
- Custom queries (i.e. jsonb queries)
- Add overloads to query methods that can be given a block
  - The blocks will be passed the table being used
  - They must return the expected criteria
  - This is so that you can have helpers that don't care about the specifics of the table but can still do common things between them
  - The most obvious example I can think of is for having an agnostic pagination helper
  - Seriously consider whether that's actually beneficial or it can be implemented cleanly the way it is right now
- Rework table definitions to not require macros (or at least as many)
  - I want to look into generating these files so if they are a bit tedious to write, it might be ok
- Separate the query builder from the database so that the sql generation can be tested (or used) without requiring a database connection
- Subselects in the FROM clause (probably elsewhere too, but start there)
  - need to be able to get columns from this subselect appropriately (and when it's aliased!)
- Look at golang's jet library for more inspiration [https://github.com/go-jet/jet]
- Update multiple rows with sql like `"UPDATE users SET custom_value = new_vals.custom_value FROM (VALUES (1, 'abc'), (2, 'def')) new_vals (id, custom_value) WHERE users.id = new_vals.id`
  - jet docs [https://github.com/go-jet/jet/wiki/VALUES] (looks like there are differences between databases)
- RETURNING support
  - add for INSERT and UPDATE
  - remove `insert_returning_generated_key`
- Change how insert works so you can pass multiple rows

## Contributing

1. Fork it (<https://github.com/matthewmcgarvey/focus/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [matthewmcgarvey](https://github.com/matthewmcgarvey) - creator and maintainer
