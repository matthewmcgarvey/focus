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
end

database.with_connection do |conn|
  conn.exec("create table if not exists users(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(128));")
end

database.insert(Users) do
  set(Users.name, "bobby")
end

database.insert(Users) do
  set(Users.name, "billy")
end

database.update(Users) do
  set(Users.name, "sally")
  where(Users.name.eq("billy"))
end

query = database.from(Users)
  .select(Users.columns)
  .where(Users.name.eq("sally"))

# puts query.to_sql
query.each do |row|
  # val = {id: row.get_int32(0)}
  val = {name: row.get(Users.name), id: row.get(Users.id)}
  # val = {count: row.get_int32(0)}
  pp val
end

database.close
