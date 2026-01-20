module Gen::Test::Public::Tables
  class PassengersTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter first_name : Focus::StringColumn
    getter last_name : Focus::StringColumn
    getter email : Focus::StringColumn
    getter birth_date : Focus::DateColumn
    getter preferences : Focus::JsonbColumn

    def initialize(schema_name : String? = nil, table_name : String = "passengers", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @first_name = Focus::StringColumn.new("first_name", table_name)
      @last_name = Focus::StringColumn.new("last_name", table_name)
      @email = Focus::StringColumn.new("email", table_name)
      @birth_date = Focus::DateColumn.new("birth_date", table_name)
      @preferences = Focus::JsonbColumn.new("preferences", table_name)
      columns = [@id, @first_name, @last_name, @email, @birth_date, @preferences].select(Focus::Expression)

      super(
       schema_name: schema_name,
       table_name: table_name,
       table_alias: table_alias,
       columns: columns
      )
    end
  end

  Passengers = PassengersTable.new
end
