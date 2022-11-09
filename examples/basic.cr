require "sqlite3"
require "../src/stealth"

database = Stealth::Database.connect("sqlite3://./data.db")

class Users
  extend Stealth::Table

  class_getter table_name : String = "users"
  class_getter columns : Array(Stealth::BaseColumn) do
    [
      id,
      name,
      age,
    ] of Stealth::BaseColumn
  end
  class_getter id : Stealth::Column(Int32) do
    Stealth::Column.new(table: self, name: "id", sql_type: Int32)
  end
  class_getter name : Stealth::Column(String) do
    Stealth::Column.new(table: self, name: "name", sql_type: String)
  end
  class_getter age : Stealth::Column(Int32) do
    Stealth::Column.new(table: self, name: "age", sql_type: Int32)
  end
end

class Todos
  extend Stealth::Table

  class_getter table_name : String = "todos"
  class_getter columns : Array(Stealth::BaseColumn) do
    [
      id,
      name,
      user_id,
    ] of Stealth::BaseColumn
  end
  class_getter id : Stealth::Column(Int32) do
    Stealth::Column.new(table: self, name: "id", sql_type: Int32)
  end
  class_getter name : Stealth::Column(String) do
    Stealth::Column.new(table: self, name: "name", sql_type: String)
  end
  class_getter user_id : Stealth::Column(Int32) do
    Stealth::Column.new(table: self, name: "user_id", sql_type: Int32)
  end
end

database.with_connection do |conn|
  conn.exec(<<-SQL)
    create table if not exists
      users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name varchar(128),
        age INTEGER
      );
  SQL

  conn.exec(<<-SQL)
    create table if not exists
      todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name varchar(128),
        user_id INTEGER
      );
  SQL
end

database.insert(Users) do
  set(Users.name, "bobby")
  set(Users.age, 45)
end

database.insert(Users) do
  set(Users.name, "billy")
  set(Users.age, 24)
end

database.insert(Todos) do
  set(Todos.name, "Take out trash")
  set(Todos.user_id, 2)
end

query = database.from(Todos)
  .select
  .where_with_or_conditions do |conditions|
    conditions << Todos.id.eq(9)
    conditions << Todos.id.less_than(5)
  end

# puts query.to_sql
query.each do |row|
  # pp row.columns.map { |col| {name: col.name, value: col.value} }
  # val = {id: row.get_int32(0)}
  # val = {name: row.get(Users.name), id: row.get(Users.id), age: row.get(Users.age)}
  val = {name: row.get(Todos.name), id: row.get(Todos.id), user_id: row.get(Todos.user_id)}
  # val = {count: row.get_int32(0)}
  # val = {name: row.get(Todos.name)}
  pp val
end

database.close
