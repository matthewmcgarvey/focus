class EmployeesTable < Focus::Table
  getter id : Focus::Int32Column
  getter name : Focus::StringColumn
  getter job : Focus::StringColumn
  getter manager_id : Focus::Int32Column
  getter hire_date : Focus::StringColumn
  getter salary : Focus::Int32Column
  getter department_id : Focus::Int32Column
  getter is_remote : Focus::BoolColumn

  def initialize(table_name : String = "employees", table_alias : String? = nil)
    @id = Focus::Int32Column.new("id", table_name)
    @name = Focus::StringColumn.new("name", table_name)
    @job = Focus::StringColumn.new("job", table_name)
    @manager_id = Focus::Int32Column.new("manager_id", table_name)
    @hire_date = Focus::StringColumn.new("hire_date", table_name)
    @salary = Focus::Int32Column.new("salary", table_name)
    @department_id = Focus::Int32Column.new("department_id", table_name)
    @is_remote = Focus::BoolColumn.new("is_remote", table_name)
    columns = [@id, @name, @job, @manager_id, @hire_date, @salary, @department_id, @is_remote]

    super(table_name, table_alias, columns)
  end
end

Employees = EmployeesTable.new
