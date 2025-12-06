class DepartmentsTable < Focus::Table
  getter id : Focus::Int32Column
  getter name : Focus::StringColumn
  getter location : Focus::StringColumn

  def initialize(table_name : String = "departments", table_alias : String? = nil)
    @id = Focus::Int32Column.new("id")
    @name = Focus::StringColumn.new("name")
    @location = Focus::StringColumn.new("location")
    columns = [id, name, location]

    super(table_name, table_alias, columns)
  end
end

Departments = DepartmentsTable.new
