require "./pg_test_base"

class PGInsertTest < PGTestBase
  def test_simple_insert
    in_transaction do |conn|
      ids = Departments.insert(Departments.name, Departments.location)
        .values("r&d", "basement")
        .values("hr", "hawaii")
        .returning(Departments.id)
        .query_all(conn, as: Int32)
      assert_equal 2, ids.size

      result = Departments.select(Departments.name).query_all(conn, String)
      assert_equal ["tech", "finance", "r&d", "hr"], result
    end
  end
end
