module Gen::Test::Public::Tables
  class BookingsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter passenger_id : Focus::IntColumn(Int32)
    getter booked_at : Focus::TimestampColumn
    getter total_amount : Focus::FloatColumn(Float64)
    getter status : Focus::StringColumn

    def initialize(schema_name : String? = nil, table_name : String = "bookings", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @passenger_id = Focus::IntColumn(Int32).new("passenger_id", table_name)
      @booked_at = Focus::TimestampColumn.new("booked_at", table_name)
      @total_amount = Focus::FloatColumn(Float64).new("total_amount", table_name)
      @status = Focus::StringColumn.new("status", table_name)
      columns = [@id, @passenger_id, @booked_at, @total_amount, @status].select(Focus::Expression)

      super(
        schema_name: schema_name,
        table_name: table_name,
        table_alias: table_alias,
        columns: columns
      )
    end
  end

  Bookings = BookingsTable.new
end
