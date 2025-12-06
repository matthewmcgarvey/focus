require "../test_base"

class FocusUpdateTest < TestBase
  def test_simple_update
    stmt = Departments.update
      .set(Departments.name, "foo")
      .where(Departments.id.eq(1))
    sql, args = stmt.to_sql_with_args

    assert_equal "UPDATE departments SET name = ? WHERE departments.id = ?", formatted(sql)
    assert_equal ["foo", 1], args.map(&.value)
  end

  def test_set_from_select
    stmt = Departments.update
      .set(Departments.name, Focus.select(Departments.name).from(Departments).where(Departments.id.eq(2)))
      .where(Departments.id.eq(1))
    sql, args = stmt.to_sql_with_args

    expected_sql = formatted(<<-SQL)
      UPDATE departments
      SET name =
        (SELECT departments.name
        FROM departments
        WHERE departments.id = ?)
      WHERE departments.id = ?
    SQL
    assert_equal expected_sql, formatted(sql)
    assert_equal [2, 1], args.map(&.value)
  end

  def test_returning
    stmt = Departments.update.set(Departments.name, "foo").returning(Departments.id)
    sql, args = stmt.to_sql_with_args

    assert_equal "UPDATE departments SET name = ? RETURNING departments.id", formatted(sql)
    assert_equal ["foo"], args.map(&.value)
  end
end
