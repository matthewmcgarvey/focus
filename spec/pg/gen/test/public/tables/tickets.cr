module Gen::Test::Public::Tables
  class TicketsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter booking_id : Focus::IntColumn(Int32)
    getter passenger_id : Focus::IntColumn(Int32)
    getter issued_at : Focus::TimestampColumn
    getter uuid : Focus::StringColumn
    getter status : Focus::StringColumn
    getter is_refundable : Focus::BoolColumn

    def initialize(schema_name : String? = nil, table_name : String = "tickets", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @booking_id = Focus::IntColumn(Int32).new("booking_id", table_name)
      @passenger_id = Focus::IntColumn(Int32).new("passenger_id", table_name)
      @issued_at = Focus::TimestampColumn.new("issued_at", table_name)
      @uuid = Focus::StringColumn.new("uuid", table_name)
      @status = Focus::StringColumn.new("status", table_name)
      @is_refundable = Focus::BoolColumn.new("is_refundable", table_name)
      columns = [@id, @booking_id, @passenger_id, @issued_at, @uuid, @status, @is_refundable].select(Focus::Expression)

      super(
        schema_name: schema_name,
        table_name: table_name,
        table_alias: table_alias,
        columns: columns
      )
    end
  end

  Tickets = TicketsTable.new
end
