require "./pg_test_base"

class PGDeleteTest < PGTestBase
  def test_simple_delete
    refute_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(database, Int32)

    Employees.delete.where(Employees.id.eq(1)).exec(database)

    assert_nil Employees.select(Employees.id).where(Employees.id.eq(1)).query_one?(database, Int32)
  end
end
