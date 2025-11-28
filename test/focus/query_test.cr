require "../test_base"

class FocusQueryTest < TestBase
  def test_simple_select
    stmt = Employees.select(Employees.name)

    assert_equal "select employees.name from employees", stmt.to_sql
  end

  def test_select_with_where
    stmt = Employees.select(Employees.name).where(Employees.salary.greater_than(80))

    assert_equal "select employees.name from employees where employees.salary > ?", stmt.to_sql
  end

  def test_select_star
    stmt = Employees.select

    assert_equal "select * from employees", stmt.to_sql
  end

  def test_order_by
    stmt1 = Employees.select.order_by(Employees.salary.desc)
    stmt2 = Employees.select.order_by(Employees.name.asc, Employees.salary.desc)

    assert_equal "select * from employees order by employees.salary desc", stmt1.to_sql
    assert_equal "select * from employees order by employees.name asc, employees.salary desc", stmt2.to_sql
  end

  def test_limit_offset
    stmt1 = Employees.select.limit(10)
    stmt2 = Employees.select.offset(15)
    stmt3 = Employees.select.limit(4).offset(5)

    assert_equal "select * from employees limit 10", stmt1.to_sql
    assert_equal "select * from employees offset 15", stmt2.to_sql
    assert_equal "select * from employees limit 4 offset 5", stmt3.to_sql
  end

  def test_group_by_having
    stmt = Employees.select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(Focus.column("employee_count", Int32).greater_than(1))

    assert_equal "select employees.department_id, count(employees.id) as employee_count from employees group by employees.department_id having employee_count > ?", stmt.to_sql
  end

  def test_select_distinct
    stmt1 = Employees.select(Employees.department_id).distinct
    stmt2 = Employees.select(Employees.department_id, Employees.name).distinct

    assert_equal "select distinct employees.department_id from employees", stmt1.to_sql
    assert_equal "select distinct employees.department_id, employees.name from employees", stmt2.to_sql
  end

  def test_drop_take
    stmt1 = Employees.select.drop(5)
    stmt2 = Employees.select.take(10)
    stmt3 = Employees.select.drop(3).take(7)
    stmt4 = Employees.select.drop(0)
    stmt5 = Employees.select.offset(5).drop(2)
    stmt6 = Employees.select.limit(5).take(10)

    assert_equal "select * from employees offset 5", stmt1.to_sql
    assert_equal "select * from employees limit 10", stmt2.to_sql
    assert_equal "select * from employees limit 7 offset 3", stmt3.to_sql
    assert_equal "select * from employees", stmt4.to_sql
    assert_equal "select * from employees offset 7", stmt5.to_sql
    assert_equal "select * from employees limit 5", stmt6.to_sql
  end

  def test_cross_join
    stmt = Focus.select.from(
      Employees.cross_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "select * from employees cross join departments on employees.department_id = departments.id", stmt.to_sql
  end

  def test_inner_join
    stmt = Focus.select.from(
      Employees.inner_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "select * from employees inner join departments on employees.department_id = departments.id", stmt.to_sql
  end

  def test_left_join
    stmt = Focus.select.from(
      Employees.left_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "select * from employees left join departments on employees.department_id = departments.id", stmt.to_sql
  end

  def test_right_join
    stmt = Focus.select.from(
      Employees.right_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    assert_equal "select * from employees right join departments on employees.department_id = departments.id", stmt.to_sql
  end

  def test_multiple_joins
    stmt = Focus.select.from(
      Employees
        .inner_join(Departments, on: Employees.department_id.eq(Departments.id))
        .left_join(Users, on: Employees.id.eq(Users.employee_id))
    )

    expected_sql = "select * from employees " +
                   "inner join departments on employees.department_id = departments.id " +
                   "left join users on employees.id = users.employee_id"
    assert_equal expected_sql, stmt.to_sql
  end

  def test_subselect_in_where_clause
    subquery = Employees.select(Employees.department_id).where(Employees.salary.greater_than(90))

    departments = Departments.select
      .where(Departments.id.in_list(subquery))
      .order_by(Departments.id.asc)

    expected_sql = formatted(<<-SQL)
      select * from departments where departments.id in
      (select employees.department_id from employees where employees.salary > ?)
      order by departments.id asc
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
      select e.name from employees e
      where e.salary > ?
      order by e.id asc
    SQL
    assert_equal expected_sql, sql.to_sql
  end

  def test_subselect_in_from_clause
    subquery = Employees.select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(Focus.column("employee_count", Int32).greater_than(1))
      .as_table("dept_counts")

    query = subquery.select.order_by(subquery.column("employee_count", Int32).desc)

    expected_sql = formatted(<<-SQL)
      select * from
      (select employees.department_id, count(employees.id) as employee_count
       from employees
       group by employees.department_id
       having employee_count > ?) dept_counts
      order by dept_counts.employee_count desc
    SQL
    assert_equal expected_sql, query.to_sql
  end
end
