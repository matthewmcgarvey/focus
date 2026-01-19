module Table
  class TicketsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter booking_id : Focus::IntColumn(Int32)
    getter passenger_id : Focus::IntColumn(Int32)
    getter issued_at : Focus::TimestampColumn
    getter status : Focus::StringColumn
    getter is_refundable : Focus::BoolColumn

    def initialize(table_name : String = "tickets", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @booking_id = Focus::IntColumn(Int32).new("booking_id", table_name)
      @passenger_id = Focus::IntColumn(Int32).new("passenger_id", table_name)
      @issued_at = Focus::TimestampColumn.new("issued_at", table_name)
      @status = Focus::StringColumn.new("status", table_name)
      @is_refundable = Focus::BoolColumn.new("is_refundable", table_name)
      columns = [@id, @booking_id, @passenger_id, @issued_at, @status, @is_refundable].select(Focus::Expression)

      super(table_name, table_alias, columns)
    end
  end

  Tickets = TicketsTable.new
end
