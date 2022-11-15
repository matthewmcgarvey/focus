require "../src/stealth"
require "../src/sqlite"

database = Stealth::SQLiteDatabase.connect("sqlite3://./data.db")

Stealth::Table.define Users, "users" do
  column id : Int32
  column name : String
  column role : String
end

Stealth::Table.define Todos, "todos" do
  column id : Int32
  column name : String
  column user_id : Int32
end

database.with_connection do |conn|
  conn.exec(<<-SQL)
    create table if not exists
      users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name varchar(128),
        role varchar(64)
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
  set(Users.role, "user")
end

database.insert(Users) do
  set(Users.name, "billy")
  set(Users.role, "admin")
end

database.insert(Todos) do
  set(Todos.name, "Take out trash")
  set(Todos.user_id, 2)
end

# database.delete(Users, Users.name.eq("billy"))
# database.delete_all(Users)

query = database.from(Users)
  .select(Users.id)
  .where(Users.role.eq("admin"))

puts query.map(&.get?(0, Int32))
puts query.to_sql
query.each do |row|
  # pp row.columns.map { |col| {name: col.name, value: col.value} }
  val = {id: row.get?(0, Int32).as(Int32?)}
  # val = {name: row.get?(Users.name), id: row.get?(Users.id), role: row.get?(Users.role)}
  # val = {name: row.get?(Users.name), count: row.get?(1, Int32)}
  # val = {name: row.get?(Todos.name), id: row.get?(Todos.id), user_id: row.get?(Todos.user_id)}
  # val = {count: row.get?(0, Int32)}
  # val = {name: row.get?(nickname)}
  pp val
end

database.close
