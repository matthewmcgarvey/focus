require "../src/stealth"
require "../src/sqlite"

database = Stealth::SQLiteDatabase.connect("sqlite3://./data.db")

class UsersTable < Stealth::Table
  @table_name = "users"

  column id : Int32
  column name : String
  column role : String
end

Users = UsersTable.new

class TodosTable < Stealth::Table
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

  def initialize(row : Stealth::CachedRow)
    @id = row.get(Todos.id)
    @name = row.get(Todos.name)
    @user = User.new(
      id: row.get(3, Int32),
      name: row.get(4, String),
      role: row.get(Users.role)
    )
  end
end

struct User
  getter id : Int32
  getter name : String
  getter role : String

  def initialize(row : Stealth::CachedRow)
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
  .select
  .bind_to(Todo)

database.close
