# Focus

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
     focus:
       github: matthewmcgarvey/focus
   ```

2. Run `shards install`

## Usage

### Connect to a database

The aim of focus is to provide fluent access to many different types of databases.
Focus will provide any extra functionality for each supported database or ways of providing it yourself.

```crystal
require "focus"
require "focus/sqlite"

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
class UsersTable < Focus::Table
  @table_name = "users"

  column id : Int32
  column name : String
  column role : String
end

Users = UsersTable.new
```

We define the table `UsersTable` with the table name and the columns.
We then create an instance and assign it to `Users` for a nice API.

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

1. Fork it (<https://github.com/matthewmcgarvey/focus/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [matthewmcgarvey](https://github.com/matthewmcgarvey) - creator and maintainer
