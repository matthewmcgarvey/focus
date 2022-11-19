require "./pg_test_base"

class PGDatabaseTest < PGTestBase
  def test_it_works
    database.insert(Departments) do
      set(Departments.name, "r&d")
      set(Departments.location, "Boston")
    end

    count = database.from(Departments)
      .select(Focus.count(Departments.id))
      .where(Departments.name.eq("r&d"))
      .first
      .get(0, Int32)

    assert_equal 1, count

    database.delete(Departments, where: Departments.name.eq("r&d"))

    count = database.from(Departments)
      .select(Focus.count(Departments.id))
      .where(Departments.name.eq("r&d"))
      .first
      .get(0, Int32)

    assert_equal 0, count
  end

  def test_limit
    query = database.from(Employees).select.order_by(Employees.id.desc).limit(offset: 0, limit: 2)

    assert_equal [4, 3], query.map(&.get(Employees.id))
  end

  def test_both_limit_and_offset_are_not_positive
    query = database.from(Employees).select.order_by(Employees.id.desc).limit(offset: 0, limit: -1)

    assert_equal [4, 3, 2, 1], query.map(&.get(Employees.id))
  end

  def test_limit_without_offset
    query = database.from(Employees).select.order_by(Employees.id.desc).limit(2)

    assert_equal [4, 3], query.map(&.get(Employees.id))
  end

  def test_offset_without_limit
    query = database.from(Employees).select.order_by(Employees.id.desc).offset(2)

    assert_equal [2, 1], query.map(&.get(Employees.id))
  end

  def test_offset_with_limit
    query = database.from(Employees).select.order_by(Employees.id.desc).offset(2).limit(1)

    assert_equal [2], query.map(&.get(Employees.id))
  end
end
