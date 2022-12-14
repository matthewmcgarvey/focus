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

struct Todo
  getter id : Int32
  getter name : String
  getter user : User

  def initialize(row : Focus::CachedRow)
    @id = row.get(Todos.id)
    @name = row.get(Todos.name)
    @user = User.new(
      id: row.get(Users.id.aliased("users_id")),
      name: row.get(Users.name.aliased("users_name")),
      role: row.get(Users.role.aliased("users_role"))
    )
  end
end

struct User
  getter id : Int32
  getter name : String
  getter role : String

  def initialize(row : Focus::CachedRow)
    @id = row.get(Users.id)
    @name = row.get(Users.name)
    @role = row.get(Users.role)
  end

  def initialize(@id, @name, @role)
  end
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
  .select(Todos.id, Todos.name, Users.id.aliased("users_id"), Users.name.aliased("users_name"), Users.role.aliased("users_role"))
  .bind_to(Todo)

database.close
