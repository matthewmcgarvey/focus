require "./sqlite_test_base"

class SQLiteDeleteTest < SQLiteTestBase
  def test_simple_delete
    refute_nil Focus.select(Employees.id).from(Employees).where(Employees.id.eq(1)).query_one?(database, Int32)

    Employees.delete.where(Employees.id.eq(1)).exec(database)

    assert_nil Focus.select(Employees.id).from(Employees).where(Employees.id.eq(1)).query_one?(database, Int32)
  end
end
