require "../test_base"

class FocusInsertTest < TestBase
  def test_simple_insert
    stmt = Departments.insert(Departments.name, Departments.location).values("hr", "antarctica")
    sql, args = stmt.format_expression

    assert_equal "insert into departments (name, location) values (?, ?)", formatted(sql)
    assert_equal ["hr", "antarctica"], args.map(&.value)
  end

  def test_insert_multiple
    stmt = Departments.insert(Departments.name, Departments.location)
      .values("hr", "antarctica")
      .values("r&d", "basement")
    sql, args = stmt.format_expression

    assert_equal "insert into departments (name, location) values (?, ?), (?, ?)", formatted(sql)
    assert_equal ["hr", "antarctica", "r&d", "basement"], args.map(&.value)
  end

  def test_insert_from_query
    stmt = Departments.insert(Departments.name, Departments.location)
      .query(
        Focus.select(Departments.name, Departments.location)
          .from(Departments)
          .where(Departments.id.eq(1)))
    sql, args = stmt.format_expression

    assert_equal "insert into departments (name, location) select departments.name, departments.location from departments where departments.id = ?", formatted(sql)
    assert_equal [1], args.map(&.value)
  end

  def test_insert_returning
    stmt = Departments.insert(Departments.name, Departments.location)
      .values("hr", "antarctica")
      .returning(Departments.id)
    sql, _ = stmt.format_expression

    assert_equal "insert into departments (name, location) values (?, ?) returning departments.id", formatted(sql)
  end
end
