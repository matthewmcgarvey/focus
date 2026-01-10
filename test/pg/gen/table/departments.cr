class DepartmentsTable < Focus::PGTable
  getter id : Focus::Int32Column
  getter name : Focus::StringColumn
  getter location : Focus::StringColumn
  getter mixedCase : Focus::StringColumn

  def initialize(table_name : String = "departments", table_alias : String? = nil)
    @id = Focus::Int32Column.new("id", table_name)
    @name = Focus::StringColumn.new("name", table_name)
    @location = Focus::StringColumn.new("location", table_name)
    @mixedCase = Focus::StringColumn.new("mixedCase", table_name)
    columns = [@id, @name, @location, @mixedCase].select(Focus::Column) # lame but necessary cast here (fails if all columns are the same type)

    super(table_name, table_alias, columns)
  end
end

Departments = DepartmentsTable.new
