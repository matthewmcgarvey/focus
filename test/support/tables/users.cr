class UsersTable < Focus::Table
  @table_name = "users"

  getter id : Focus::Int32Column
  getter username : Focus::StringColumn
  getter email : Focus::StringColumn
  getter employee_id : Focus::Int32Column

  def initialize(table_name : String = "users", table_alias : String? = nil)
    @id = Focus::Int32Column.new("id", table_name)
    @username = Focus::StringColumn.new("username", table_name)
    @email = Focus::StringColumn.new("email", table_name)
    @employee_id = Focus::Int32Column.new("employee_id", table_name)
    columns = [@id, @username, @email, @employee_id]

    super(table_name, table_alias, columns)
  end
end

Users = UsersTable.new
