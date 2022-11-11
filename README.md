# Stealth

SQL query builder for multiple databases. Heavily inspired by Kotlin's [Ktorm](https://www.ktorm.org).

Not at all ready for real use. (There's not even any tests, so don't be crazy and try to use it for real.)

## Goals

- Support more types of SQL queries
- Separate data models from database tables
- Work with multiple database types
- Use less macros

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     stealth:
       github: matthewmcgarvey/stealth
   ```

2. Run `shards install`

## Usage

### Connect to a database

The aim of stealth is to provide fluent access to many different types of databases.
Stealth will provide any extra functionality for each supported database or ways of providing it yourself.

```crystal
require "stealth"
require "stealth/sqlite"

database = SQLiteDatabase.connect("sqlite3://./data.db")
```

Databases currently supported:

- SQLite3
- Postgresql
- Mysql

### Define a table

Tables are where we connect Crystal code to the database tables.
It's important to understand that these are not our data models.
They are used to build queries.

```crystal
Stealth::Table.define Users, "users" do
  column id : Int32
  column name : String
  column role : String
end
```

The first argument `Users` defines the class that you will use to reference the table.
The second argument is the definitive table name that it will use.
Each column of the table is then defined in a block using `column` and a type declaration.

**A note about macros in this library**

It is a goal of Stealth to make the library as macro-free as possible.
Ideally, there would be no macros but the way tables are defined would be unpleasant without the macros.

Here is what the above table generates, and if you hate macros, this is to show that you don't have to use them.

```crystal
class Users
  COLUMNS = [] of Stealth::BaseColumn
  extend Stealth::Table

  class_getter table_name : String = "user"
  class_getter column : Array(Stealth::BaseColumn) = COLUMNS

  COLUMNS << id
  class_getter id : Stealth::Column(Int32) do
    Stealth::Column.new(table: self, name: "id", sql_type: Int32)
  end

  COLUMNS << name
  class_getter name : Stealth::Column(String) do
    Stealth::Column.new(table: self, name: "name", sql_type: String)
  end

  COLUMNS << role
  class_getter role : Stealth::Column(String) do
    Stealth::Column.new(table: self, name: "role", sql_type: String)
  end
end
```

### Make a query

```crystal
database.from(Users)
  .select(Users.id)
  .where(Users.role.eq("admin"))
  .map(&.get(Users.id))
```

### Insert data

```crystal
database.insert(Users) do
  set(Users.name, "bobby")
  set(Users.role, "user")
end
```

### Update data

```crystal
database.update(Users) do
  set(Users.role, "admin")
  where(Users.name.eq("bobby"))
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/matthewmcgarvey/stealth/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [matthewmcgarvey](https://github.com/matthewmcgarvey) - creator and maintainer
