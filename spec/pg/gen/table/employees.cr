module Tables
  class EmployeesTable < Focus::PGTable
    getter id : Focus::IntColumn(Int32)
    getter name : Focus::StringColumn
    getter job : Focus::StringColumn
    getter manager_id : Focus::IntColumn(Int32)
    getter hire_date : Focus::TimeColumn
    getter salary : Focus::IntColumn(Int64)
    getter department_id : Focus::IntColumn(Int32)
    getter is_remote : Focus::BoolColumn

    def initialize(table_name : String = "employees", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @name = Focus::StringColumn.new("name", table_name)
      @job = Focus::StringColumn.new("job", table_name)
      @manager_id = Focus::IntColumn(Int32).new("manager_id", table_name)
      @hire_date = Focus::TimeColumn.new("hire_date", table_name)
      @salary = Focus::IntColumn(Int64).new("salary", table_name)
      @department_id = Focus::IntColumn(Int32).new("department_id", table_name)
      @is_remote = Focus::BoolColumn.new("is_remote", table_name)
      columns = [@id, @name, @job, @manager_id, @hire_date, @salary, @department_id, @is_remote].select(Focus::Expression)

      super(table_name, table_alias, columns)
    end
  end

  Employees = EmployeesTable.new
end
