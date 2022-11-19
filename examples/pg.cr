require "../src/stealth"
require "../src/pg"

database = Stealth::PGDatabase.connect("postgresql://lucky@localhost:5432/avram_dev")

class UsersTable < Stealth::Table
  @table_name = "users"

  column id : Int32
  column name : String
  column age : Int32
  column year_born : Int16
  column nickname : String
  column joined_at : Time
  column total_score : Int64
  column average_score : Float32
  column available_for_hire : Bool
  column created_at : Time
  column updated_at : Time
end

Users = UsersTable.new

struct User
  getter id : Int32
  getter name : String
  getter age : Int32
  getter year_born : Int16

  def initialize(row : Stealth::CachedRow)
    @id = row.get(Users.id)
    @name = row.get(Users.name)
    @age = row.get(Users.age)
    @year_born = row.get(Users.year_born)
  end
end

database.insert(Users) do
  set(Users.name, "William")
  set(Users.age, 39)
  set(Users.year_born, 1983)
  set(Users.nickname, "Bob")
  set(Users.joined_at, Time.utc)
  set(Users.total_score, 100)
  set(Users.created_at, Time.utc)
  set(Users.updated_at, Time.utc)
  set(Users.available_for_hire, true)
  set(Users.average_score, 45.78)
end

pp database.from(Users)
  .select(Users.id, Users.name, Users.age, Users.year_born)
  .bind_to(User)

database.close
