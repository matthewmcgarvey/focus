require "./sqlite_test_base"

class SQLiteDeleteTest < SQLiteTestBase
  def test_simple_delete
    in_transaction do |conn|
      refute_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(conn, Int32)

      Employees.delete.where(Employees.id.eq(1)).exec(conn)

      assert_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(conn, Int32)
    end
  end

  def test_delete_returning
    in_transaction do |conn|
      ids = Employees.delete.returning(Employees.id).query_all(conn, Int32)
      assert ids.size > 0

      assert_equal 0, Employees.select(Focus.count(Employees.id)).query_one(conn, Int64)
    end
  end
end
