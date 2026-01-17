module Tables
  class AircraftsTable < Focus::SQLiteTable
    getter id : Focus::IntColumn(Int32)
    getter tail_number : Focus::StringColumn
    getter model : Focus::StringColumn
    getter seat_capacity : Focus::IntColumn(Int32)

    def initialize(table_name : String = "aircrafts", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @tail_number = Focus::StringColumn.new("tail_number", table_name)
      @model = Focus::StringColumn.new("model", table_name)
      @seat_capacity = Focus::IntColumn(Int32).new("seat_capacity", table_name)
      columns = [@id, @tail_number, @model, @seat_capacity].select(Focus::Expression)

      super(table_name, table_alias, columns)
    end
  end

  Aircrafts = AircraftsTable.new
end
