module Gen::Test::Public::Tables
  class FlightsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter flight_number : Focus::StringColumn
    getter aircraft_id : Focus::IntColumn(Int32)
    getter depart_airport_id : Focus::IntColumn(Int32)
    getter arrive_airport_id : Focus::IntColumn(Int32)
    getter depart_time : Focus::TimestampColumn
    getter arrive_time : Focus::TimestampColumn
    getter status : Focus::StringColumn

    def initialize(schema_name : String? = nil, table_name : String = "flights", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @flight_number = Focus::StringColumn.new("flight_number", table_name)
      @aircraft_id = Focus::IntColumn(Int32).new("aircraft_id", table_name)
      @depart_airport_id = Focus::IntColumn(Int32).new("depart_airport_id", table_name)
      @arrive_airport_id = Focus::IntColumn(Int32).new("arrive_airport_id", table_name)
      @depart_time = Focus::TimestampColumn.new("depart_time", table_name)
      @arrive_time = Focus::TimestampColumn.new("arrive_time", table_name)
      @status = Focus::StringColumn.new("status", table_name)
      columns = [@id, @flight_number, @aircraft_id, @depart_airport_id, @arrive_airport_id, @depart_time, @arrive_time, @status].select(Focus::Expression)

      super(
        schema_name: schema_name,
        table_name: table_name,
        table_alias: table_alias,
        columns: columns
      )
    end
  end

  Flights = FlightsTable.new
end
