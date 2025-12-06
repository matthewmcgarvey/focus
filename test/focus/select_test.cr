require "../test_base"

class FocusSelectTest < TestBase
  def test_simple_select
    stmt = Employees.select(Employees.name)

    assert_equal "SELECT employees.name FROM employees", stmt.to_sql
  end

  def test_select_with_where
    stmt = Employees.select(Employees.name).where(Employees.salary.greater_than(80))

    assert_equal "SELECT employees.name FROM employees WHERE employees.salary > ?", stmt.to_sql
  end

  def test_select_star
    stmt = Employees.select

    assert_equal "SELECT * FROM employees", stmt.to_sql
  end

  def test_order_by
    stmt1 = Employees.select.order_by(Employees.salary.desc)
    stmt2 = Employees.select.order_by(Employees.name.asc, Employees.salary.desc)
    stmt3 = Employees.select.order_by(Employees.hire_date.asc.nulls_last)
    stmt4 = Employees.select.order_by(Employees.hire_date.asc.nulls_first)

    assert_equal "SELECT * FROM employees ORDER BY employees.salary DESC", stmt1.to_sql
    assert_equal "SELECT * FROM employees ORDER BY employees.name ASC, employees.salary DESC", stmt2.to_sql
    assert_equal "SELECT * FROM employees ORDER BY employees.hire_date ASC NULLS LAST", stmt3.to_sql
    assert_equal "SELECT * FROM employees ORDER BY employees.hire_date ASC NULLS FIRST", stmt4.to_sql
  end

  def test_limit_offset
    stmt1 = Employees.select.limit(10)
    stmt2 = Employees.select.offset(15)
    stmt3 = Employees.select.limit(4).offset(5)

    assert_equal "SELECT * FROM employees LIMIT 10", stmt1.to_sql
    assert_equal "SELECT * FROM employees OFFSET 15", stmt2.to_sql
    assert_equal "SELECT * FROM employees LIMIT 4 OFFSET 5", stmt3.to_sql
  end

  def test_group_by_having
    stmt = Employees.select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(Focus::Int32Column.new("employee_count").greater_than(1))

    assert_equal "SELECT employees.department_id, COUNT(employees.id) AS employee_count FROM employees GROUP BY employees.department_id HAVING employee_count > ?", stmt.to_sql
  end

  def test_select_distinct
    stmt1 = Employees.select(Employees.department_id).distinct
    stmt2 = Employees.select(Employees.department_id, Employees.name).distinct

    assert_equal "SELECT DISTINCT employees.department_id FROM employees", stmt1.to_sql
    assert_equal "SELECT DISTINCT employees.department_id, employees.name FROM employees", stmt2.to_sql
  end

  def test_cross_join
    stmt = Focus.select.from(
      Employees.cross_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "SELECT * FROM employees CROSS JOIN departments ON employees.department_id = departments.id", stmt.to_sql
  end

  def test_inner_join
    stmt = Focus.select.from(
      Employees.inner_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "SELECT * FROM employees INNER JOIN departments ON employees.department_id = departments.id", stmt.to_sql
  end

  def test_left_join
    stmt = Focus.select.from(
      Employees.left_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "SELECT * FROM employees LEFT JOIN departments ON employees.department_id = departments.id", stmt.to_sql
  end

  def test_right_join
    stmt = Focus.select.from(
      Employees.right_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "SELECT * FROM employees RIGHT JOIN departments ON employees.department_id = departments.id", stmt.to_sql
  end

  def test_multiple_joins
    stmt = Focus.select.from(
      Employees
        .inner_join(Departments, on: Employees.department_id.eq(Departments.id))
        .left_join(Users, on: Employees.id.eq(Users.employee_id))
    )

    expected_sql = "SELECT * FROM employees " +
                   "INNER JOIN departments ON employees.department_id = departments.id " +
                   "LEFT JOIN users ON employees.id = users.employee_id"
    assert_equal expected_sql, stmt.to_sql
  end

  def test_subselect_in_where_clause
    subquery = Employees.select(Employees.department_id).where(Employees.salary.greater_than(90))

    departments = Departments.select
      .where(Departments.id.in_list(subquery))
      .order_by(Departments.id.asc)

    expected_sql = formatted(<<-SQL)
      SELECT * FROM departments WHERE departments.id IN
      (SELECT employees.department_id FROM employees WHERE employees.salary > ?)
      ORDER BY departments.id ASC
    SQL
    assert_equal expected_sql, departments.to_sql
  end

  def test_table_alias
    aliased_table = Employees.aliased("e")
    sql = Focus.select(aliased_table.name)
      .from(aliased_table)
      .where(aliased_table.salary.greater_than(80))
      .order_by(aliased_table.id.asc)

    expected_sql = formatted(<<-SQL)
      SELECT e.name FROM employees e
      WHERE e.salary > ?
      ORDER BY e.id ASC
    SQL
    assert_equal expected_sql, sql.to_sql
  end

  def test_subselect_in_from_clause
    employee_count_col = Focus::Int32Column.new("employee_count")
    subquery = Employees.select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(employee_count_col.greater_than(1))
      .aliased("dept_counts")

    query = Focus.select.from(subquery).order_by(employee_count_col.from(subquery).desc)

    expected_sql = formatted(<<-SQL)
      SELECT * FROM
      (SELECT employees.department_id, COUNT(employees.id) AS employee_count
       FROM employees
       GROUP BY employees.department_id
       HAVING employee_count > ?) dept_counts
      ORDER BY dept_counts.employee_count DESC
    SQL
    assert_equal expected_sql, query.to_sql
  end
end
