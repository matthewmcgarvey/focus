require "../test_base"

class FocusDeleteTest < TestBase
  def test_simple_delete
    stmt = Employees.delete
    sql, args = stmt.to_sql_with_args

    assert_equal "DELETE FROM employees", formatted(sql)
    assert_empty args
  end

  def test_delete_where
    stmt = Employees.delete.where(Employees.id.eq(1))
    sql, args = stmt.to_sql_with_args

    assert_equal "DELETE FROM employees WHERE employees.id = ?", formatted(sql)
    assert_equal [1], args
  end

  def test_delete_returning
    stmt = Employees.delete.returning(Employees.id)
    sql, _ = stmt.to_sql_with_args

    assert_equal "DELETE FROM employees RETURNING employees.id", formatted(sql)
  end
end
