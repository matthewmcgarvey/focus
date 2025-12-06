require "../test_base"

class FocusDeleteTest < TestBase
  # def test_simple_delete
  #   stmt = Employees.delete
  #   sql, args = stmt.format_expression

  #   assert_equal "delete from employees", formatted(sql)
  #   assert_empty args
  # end

  # def test_delete_where
  #   stmt = Employees.delete.where(Employees.id.eq(1))
  #   sql, args = stmt.format_expression

  #   assert_equal "delete from employees where employees.id = ?", formatted(sql)
  #   assert_equal [1], args.map(&.value)
  # end

  # def test_delete_returning
  #   stmt = Employees.delete.returning(Employees.id)
  #   sql, _ = stmt.format_expression

  #   assert_equal "delete from employees returning employees.id", formatted(sql)
  # end

  # def test_order_by_limit_offset
  #   stmt = Employees.delete.order_by(Employees.name.asc).limit(2).offset(5)
  #   sql, args = stmt.format_expression

  #   assert_equal "delete from employees order by employees.name asc limit 2 offset 5", formatted(sql)
  #   assert_empty args
  # end
end
