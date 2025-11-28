require "../sqlite/sqlite_test_base"

class FocusQueryTest < SQLiteTestBase
  def test_subselect_in_where_clause
    subquery = database.from(Employees)
      .select(Employees.department_id)
      .where(Employees.salary.greater_than(90))

    departments = database.from(Departments)
      .select
      .where(Departments.id.in_list(subquery))
      .order_by(Departments.id.asc)

    assert_equal [1, 2], departments.map(&.get(Departments.id))
  end

  def test_table_alias
    aliased_table = Employees.aliased("e")
    sql = database.from(aliased_table)
      .select(aliased_table.name)
      .where(aliased_table.salary.greater_than(80))
      .order_by(aliased_table.id.asc)

    assert_equal ["vince", "tom", "penny"], sql.map(&.get(aliased_table.name))
  end

  def test_subselect_in_from_clause
    subquery = database.from(Employees)
      .select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(Focus.count(Employees.id).greater_than(1))
      .as_table("dept_counts")

    results = database.from(subquery)
      .select
      .order_by(subquery.column("employee_count", Int32).asc)

    assert_equal [[1, 2], [2, 2]], results.map { |row| [row.get("department_id", Int32), row.get("employee_count", Int32)] }
  end
end
