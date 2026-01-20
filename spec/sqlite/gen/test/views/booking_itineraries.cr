module Gen::Test::Views
  class BookingItinerariesTable < Focus::SQLite::Table
    getter booking_id : Focus::IntColumn(Int32)
    getter passenger_id : Focus::IntColumn(Int32)
    getter first_name : Focus::StringColumn
    getter last_name : Focus::StringColumn
    getter flight_id : Focus::IntColumn(Int32)
    getter flight_number : Focus::StringColumn
    getter depart_airport_code : Focus::StringColumn
    getter arrive_airport_code : Focus::StringColumn
    getter depart_time : Focus::StringColumn
    getter arrive_time : Focus::StringColumn
    getter service_class : Focus::StringColumn
    getter seat : Focus::StringColumn
    getter price : Focus::FloatColumn(Float64)
    getter booking_status : Focus::StringColumn

    def initialize(schema_name : String? = nil, table_name : String = "booking_itineraries", table_alias : String? = nil)
      @booking_id = Focus::IntColumn(Int32).new("booking_id", table_name)
      @passenger_id = Focus::IntColumn(Int32).new("passenger_id", table_name)
      @first_name = Focus::StringColumn.new("first_name", table_name)
      @last_name = Focus::StringColumn.new("last_name", table_name)
      @flight_id = Focus::IntColumn(Int32).new("flight_id", table_name)
      @flight_number = Focus::StringColumn.new("flight_number", table_name)
      @depart_airport_code = Focus::StringColumn.new("depart_airport_code", table_name)
      @arrive_airport_code = Focus::StringColumn.new("arrive_airport_code", table_name)
      @depart_time = Focus::StringColumn.new("depart_time", table_name)
      @arrive_time = Focus::StringColumn.new("arrive_time", table_name)
      @service_class = Focus::StringColumn.new("service_class", table_name)
      @seat = Focus::StringColumn.new("seat", table_name)
      @price = Focus::FloatColumn(Float64).new("price", table_name)
      @booking_status = Focus::StringColumn.new("booking_status", table_name)
      columns = [@booking_id, @passenger_id, @first_name, @last_name, @flight_id, @flight_number, @depart_airport_code, @arrive_airport_code, @depart_time, @arrive_time, @service_class, @seat, @price, @booking_status].select(Focus::Expression)

      super(
        schema_name: schema_name,
        table_name: table_name,
        table_alias: table_alias,
        columns: columns
      )
    end
  end

  BookingItineraries = BookingItinerariesTable.new
end
