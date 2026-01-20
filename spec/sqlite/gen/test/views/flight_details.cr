module Gen::Test::Views
  class FlightDetailsTable < Focus::SQLite::Table
    getter flight_id : Focus::IntColumn(Int32)
    getter flight_number : Focus::StringColumn
    getter tail_number : Focus::StringColumn
    getter aircraft_model : Focus::StringColumn
    getter seat_capacity : Focus::IntColumn(Int32)
    getter depart_code : Focus::StringColumn
    getter depart_airport : Focus::StringColumn
    getter depart_city : Focus::StringColumn
    getter arrive_code : Focus::StringColumn
    getter arrive_airport : Focus::StringColumn
    getter arrive_city : Focus::StringColumn
    getter depart_time : Focus::StringColumn
    getter arrive_time : Focus::StringColumn
    getter status : Focus::StringColumn

    def initialize(schema_name : String? = nil, table_name : String = "flight_details", table_alias : String? = nil)
      @flight_id = Focus::IntColumn(Int32).new("flight_id", table_name)
      @flight_number = Focus::StringColumn.new("flight_number", table_name)
      @tail_number = Focus::StringColumn.new("tail_number", table_name)
      @aircraft_model = Focus::StringColumn.new("aircraft_model", table_name)
      @seat_capacity = Focus::IntColumn(Int32).new("seat_capacity", table_name)
      @depart_code = Focus::StringColumn.new("depart_code", table_name)
      @depart_airport = Focus::StringColumn.new("depart_airport", table_name)
      @depart_city = Focus::StringColumn.new("depart_city", table_name)
      @arrive_code = Focus::StringColumn.new("arrive_code", table_name)
      @arrive_airport = Focus::StringColumn.new("arrive_airport", table_name)
      @arrive_city = Focus::StringColumn.new("arrive_city", table_name)
      @depart_time = Focus::StringColumn.new("depart_time", table_name)
      @arrive_time = Focus::StringColumn.new("arrive_time", table_name)
      @status = Focus::StringColumn.new("status", table_name)
      columns = [@flight_id, @flight_number, @tail_number, @aircraft_model, @seat_capacity, @depart_code, @depart_airport, @depart_city, @arrive_code, @arrive_airport, @arrive_city, @depart_time, @arrive_time, @status].select(Focus::Expression)

      super(
       schema_name: schema_name,
       table_name: table_name,
       table_alias: table_alias,
       columns: columns
      )
    end
  end

  FlightDetails = FlightDetailsTable.new
end
