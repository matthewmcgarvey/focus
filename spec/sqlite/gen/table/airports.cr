module Table
  class AirportsTable < Focus::SQLite::Table
    getter id : Focus::IntColumn(Int32)
    getter code : Focus::StringColumn
    getter name : Focus::StringColumn
    getter city : Focus::StringColumn
    getter country : Focus::StringColumn

    def initialize(table_name : String = "airports", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @code = Focus::StringColumn.new("code", table_name)
      @name = Focus::StringColumn.new("name", table_name)
      @city = Focus::StringColumn.new("city", table_name)
      @country = Focus::StringColumn.new("country", table_name)
      columns = [@id, @code, @name, @city, @country].select(Focus::Expression)

      super(table_name, table_alias, columns)
    end
  end

  Airports = AirportsTable.new
end
