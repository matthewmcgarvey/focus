class UsersTable < Focus::Table
  @table_name = "users"

  column id : Int32
  column username : String
  column email : String
  column employee_id : Int32
end

Users = UsersTable.new
