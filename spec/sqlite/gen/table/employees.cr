module Tables
  class EmployeesTable < Focus::SQLiteTable
    getter id : Focus::IntColumn(Int32)
    getter name : Focus::StringColumn
    getter job : Focus::StringColumn
    getter manager_id : Focus::IntColumn(Int32)
    getter hire_date : Focus::StringColumn
    getter salary : Focus::IntColumn(Int32)
    getter department_id : Focus::IntColumn(Int32)
    getter is_remote : Focus::BoolColumn

    def initialize(table_name : String = "employees", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @name = Focus::StringColumn.new("name", table_name)
      @job = Focus::StringColumn.new("job", table_name)
      @manager_id = Focus::IntColumn(Int32).new("manager_id", table_name)
      @hire_date = Focus::StringColumn.new("hire_date", table_name)
      @salary = Focus::IntColumn(Int32).new("salary", table_name)
      @department_id = Focus::IntColumn(Int32).new("department_id", table_name)
      @is_remote = Focus::BoolColumn.new("is_remote", table_name)
      columns = [@id, @name, @job, @manager_id, @hire_date, @salary, @department_id, @is_remote].select(Focus::Column) # lame but necessary cast here (fails if all columns are the same type)

      super(table_name, table_alias, columns)
    end
  end

  Employees = EmployeesTable.new
end
