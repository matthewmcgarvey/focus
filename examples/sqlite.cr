require "../src/stealth"
require "../src/sqlite3"

database = Stealth::SQLiteDatabase.connect("sqlite3://./data.db")

Stealth::Table.define Users, "users" do
  column id : Int32
  column name : String
  column age : Int32
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

# database.delete(Users, Users.name.eq("billy"))
# database.delete_all(Users)

query = database.sequence_of(Todos)

puts query.to_sql
query.each do |row|
  # pp row.columns.map { |col| {name: col.name, value: col.value} }
  # val = {id: row.get_int32(0)}
  # val = {name: row.get(Users.name), id: row.get(Users.id), age: row.get(Users.age)}
  # val = {name: row.get(Users.name), count: row.get_int32(1)}
  val = {name: row.get(Todos.name), id: row.get(Todos.id), user_id: row.get(Todos.user_id)}
  # val = {count: row.get_int32(0)}
  # val = {name: row.get(nickname)}
  pp val
end

database.close
