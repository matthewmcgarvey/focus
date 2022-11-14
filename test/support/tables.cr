Stealth::Table.define Departments, "departments" do
  column id : Int32
  column name : String
  column location : String
end

Stealth::Table.define Employees, "employees" do
  column id : Int32
  column name : String
  column job : String
  column manager_id : Int32
  column hire_date : Time
  column salary : Int32
  column department_id : Int32
end
