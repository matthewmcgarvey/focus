require "./pg_test_base"

class PGDeleteTest < PGTestBase
  def test_simple_delete
    in_transaction do |conn|
      refute_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(conn, Int32)

      Employees.delete.where(Employees.id.eq(1)).exec(conn)

      assert_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(conn, Int32)
    end
  end
end
