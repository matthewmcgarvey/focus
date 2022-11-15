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
