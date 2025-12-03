class DepartmentsTable < Focus::Table
  @table_name = "departments"

  @[ColumnLabel]
  getter id : Focus::Int32Column do
    Focus::Int32Column.new(table_name: self.label || self.table_name, name: "id")
  end
  @[ColumnLabel]
  getter name : Focus::StringColumn do
    Focus::StringColumn.new(table_name: self.label || self.table_name, name: "name")
  end
  @[ColumnLabel]
  getter location : Focus::StringColumn do
    Focus::StringColumn.new(table_name: self.label || self.table_name, name: "location")
  end
end

Departments = DepartmentsTable.new
