module Gen::Test::Public::Tables
  class DepartmentsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter name : Focus::StringColumn
    getter location : Focus::StringColumn
    getter mixedCase : Focus::StringColumn

    def initialize(schema_name : String? = nil, table_name : String = "departments", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @name = Focus::StringColumn.new("name", table_name)
      @location = Focus::StringColumn.new("location", table_name)
      @mixedCase = Focus::StringColumn.new("mixedCase", table_name)
      columns = [@id, @name, @location, @mixedCase].select(Focus::Expression)

      super(
       schema_name: schema_name,
       table_name: table_name,
       table_alias: table_alias,
       columns: columns
      )
    end
  end

  Departments = DepartmentsTable.new
end
