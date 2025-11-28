require "../test_base"

class FocusColumnTest < TestBase
  def test_column_sql
    assert_sql "employees.name", Employees.name
    assert_sql "departments.location", Departments.location
  end

  def test_binary
    assert_sql "employees.salary > ?", Employees.salary.greater_than(50)
    assert_sql "employees.id = ?", Employees.id.eq(45)
    assert_sql "employees.name in (?, ?, ?)", Employees.name.in_list("a", "b", "c")
  end

  def test_from_subquery
    subquery = Focus.select.from(Employees).as_table("foo")

    assert_sql "foo.salary", Focus::Column(Int32).new("salary").from(subquery)
  end

  def assert_sql(expected : String, actual : Focus::ColumnDeclaring(T)) forall T
    formatter = Focus::SqlFormatter.new
    actual.as_expression.accept(formatter)
    assert_equal expected, formatted(formatter.to_sql)
  end
end
