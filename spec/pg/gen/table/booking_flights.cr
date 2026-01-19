module Table
  class BookingFlightsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter booking_id : Focus::IntColumn(Int32)
    getter flight_id : Focus::IntColumn(Int32)
    getter seat : Focus::StringColumn
    getter service_class : Focus::StringColumn
    getter price : Focus::FloatColumn(Float64)

    def initialize(table_name : String = "booking_flights", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @booking_id = Focus::IntColumn(Int32).new("booking_id", table_name)
      @flight_id = Focus::IntColumn(Int32).new("flight_id", table_name)
      @seat = Focus::StringColumn.new("seat", table_name)
      @service_class = Focus::StringColumn.new("service_class", table_name)
      @price = Focus::FloatColumn(Float64).new("price", table_name)
      columns = [@id, @booking_id, @flight_id, @seat, @service_class, @price].select(Focus::Expression)

      super(table_name, table_alias, columns)
    end
  end

  BookingFlights = BookingFlightsTable.new
end
