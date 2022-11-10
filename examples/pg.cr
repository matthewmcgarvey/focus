require "../src/stealth"
require "../src/pg"

database = Stealth::PGDatabase.connect("postgresql://lucky@localhost:5432/avram_dev")

class Users
  extend Stealth::Table

  class_getter table_name : String = "users"
  class_getter columns : Array(Stealth::BaseColumn) do
    [
      id,
      name,
      age,
      year_born,
      nickname,
      joined_at,
      total_score,
      average_score,
      available_for_hire,
      created_at,
      updated_at,
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
  class_getter year_born : Stealth::Column(Int16) do
    Stealth::Column.new(table: self, name: "year_born", sql_type: Int16)
  end
  class_getter nickname : Stealth::Column(String) do
    Stealth::Column.new(table: self, name: "nickname", sql_type: String)
  end
  class_getter joined_at : Stealth::Column(Time) do
    Stealth::Column.new(table: self, name: "joined_at", sql_type: Time)
  end
  class_getter total_score : Stealth::Column(Int64) do
    Stealth::Column.new(table: self, name: "total_score", sql_type: Int64)
  end
  class_getter average_score : Stealth::Column(Float64) do
    Stealth::Column.new(table: self, name: "average_score", sql_type: Float64)
  end
  class_getter available_for_hire : Stealth::Column(Bool) do
    Stealth::Column.new(table: self, name: "available_for_hire", sql_type: Bool)
  end
  class_getter created_at : Stealth::Column(Time) do
    Stealth::Column.new(table: self, name: "created_at", sql_type: Time)
  end
  class_getter updated_at : Stealth::Column(Time) do
    Stealth::Column.new(table: self, name: "updated_at", sql_type: Time)
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
end

query = database.sequence_of(Users)

puts query.to_sql
query.each do |row|
  puts "User {"
  row.columns.each { |col| puts "\t#{col.name}: #{col.value}" }
  puts "}"
end
