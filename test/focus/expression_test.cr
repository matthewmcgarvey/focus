require "../test_base"

class FocusExpressionTest < TestBase
  def test_is_null
    assert_equal "departments.name IS NULL", Departments.name.is_null.to_sql
  end

  def test_is_not_null
    assert_equal "departments.name IS NOT NULL", Departments.name.is_not_null.to_sql
  end

  def test_in
    sql, args = Departments.id.in_list(Focus::GenericValueExpression.new(1), Focus::GenericValueExpression.new(2), Focus::GenericValueExpression.new(3)).to_sql_with_args
    assert_equal "departments.id IN (?, ?, ?)", sql
    assert_equal [1, 2, 3], args
  end

  def test_not_in
    sql, args = Departments.id.not_in_list(Focus::GenericValueExpression.new(1), Focus::GenericValueExpression.new(2), Focus::GenericValueExpression.new(3)).to_sql_with_args
    assert_equal "departments.id NOT IN (?, ?, ?)", sql
    assert_equal [1, 2, 3], args
  end

  def test_aliased
    aliased = Departments.name.aliased("dept_name")
    assert_equal "departments.name AS dept_name", aliased.to_sql
  end
end
