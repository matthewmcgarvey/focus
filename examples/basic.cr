require "sqlite3"
require "../src/stealth"

database = Stealth::Database.connect("sqlite3://./data.db")

class Users
  extend Stealth::Table

  class_getter table_name : String = "users"
  class_getter _columns : Array(Stealth::Column) do
    [
      id,
      name,
    ]
  end
  class_getter id : Stealth::Column do
    Stealth::Column.new(table: self, name: "id")
  end
  class_getter name : Stealth::Column do
    Stealth::Column.new(table: self, name: "name")
  end
end

database.with_connection do |conn|
  conn.exec("create table if not exists users(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(128));")
  conn.exec("INSERT INTO users(name) VALUES('bobby');")
end

database.from(Users)
  .select(Users.id, Users.name)
  .each do |row|
    val = {id: row.get_int32(0)}
    pp val
  end

database.close
