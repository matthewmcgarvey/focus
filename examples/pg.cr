require "../src/stealth"
require "../src/pg"

database = Stealth::PGDatabase.connect("postgresql://lucky@localhost:5432/avram_dev")

Stealth::Table.define Users, "users" do
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

query = database.sequence_of(Users)

puts query.to_sql
query.each do |row|
  val = {
    id:                 row.get(Users.id),
    joined_at:          row.get(Users.joined_at),
    year_born:          row.get(Users.year_born),
    total_score:        row.get(Users.total_score),
    average_score:      row.get(Users.average_score),
    available_for_hire: row.get(Users.available_for_hire),
  }
  puts val
end
