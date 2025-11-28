class DepartmentsTable < Focus::Table
  @table_name = "departments"

  column id : Int32
  column name : String
  column location : String
end

Departments = DepartmentsTable.new

class EmployeesTable < Focus::Table
  @table_name = "employees"

  column id : Int32
  column name : String
  column job : String
  column manager_id : Int32
  column hire_date : Time
  column salary : Int32
  column department_id : Int32
  column is_remote : Bool
end

Employees = EmployeesTable.new

class UsersTable < Focus::Table
  @table_name = "users"

  column id : Int32
  column username : String
  column email : String
  column employee_id : Int32
end

Users = UsersTable.new
