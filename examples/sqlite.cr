require "../src/focus"
require "../src/sqlite"

database = Focus::SQLiteDatabase.connect("sqlite3://./data.db")

class UsersTable < Focus::Table
  @table_name = "users"

  column id : Int32
  column name : String
  column role : String
end

Users = UsersTable.new

class TodosTable < Focus::Table
  @table_name = "todos"

  column id : Int32
  column name : String
  column user_id : Int32
end

Todos = TodosTable.new

class TodoWithUser
  include DB::Serializable

  property id : Int64
  property name : String
  property user_id : Int64
  property user_name : String
  property user_role : String
end

class User
  include DB::Serializable

  property id : Int64
  property name : String
  property role : String
end

database.with_connection do |conn|
  conn.exec(<<-SQL)
    create table if not exists
      users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name varchar(128) not null,
        role varchar(64) not null
      );
  SQL

  conn.exec(<<-SQL)
    create table if not exists
      todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name varchar(128) not null,
        user_id INTEGER not null
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

pp database.from(Todos)
  .left_join(Users, on: Todos.user_id.eq(Users.id))
  .select(Todos.id, Todos.name, Todos.user_id, Users.name.aliased("user_name"), Users.role.aliased("user_role"))
  .bind_to(TodoWithUser)

database.close
