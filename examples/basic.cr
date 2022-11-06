require "sqlite3"
require "../src/stealth"

database = Stealth::Database.connect("sqlite3://./data.db")

class Users
  extend Stealth::Table

  class_getter table_name : String = "users"
  class_getter _columns : Array(Stealth::BaseColumn) do
    [
      id,
      name,
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

database.with_connection do |conn|
  conn.exec("create table if not exists users(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(128), age INTEGER);")
end

database.insert(Users) do
  set(Users.name, "bobby")
  set(Users.age, 45)
end

database.insert(Users) do
  set(Users.name, "billy")
  set(Users.age, 24)
end

query = database.from(Users)
  .select(Users.age)
  .where(Users.age.not_eq 45)

# puts query.to_sql
query.each do |row|
  # val = {id: row.get_int32(0)}
  # val = {name: row.get(Users.name), id: row.get(Users.id)}
  val = {count: row.get_int32(0)}
  pp val
end

database.close
