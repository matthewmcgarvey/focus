require "./sqlite_test_base"

class SQLiteInsertTest < SQLiteTestBase
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

  def test_insert_from_query
    in_transaction do |conn|
      Departments.insert(Departments.name, Departments.location)
        .query(
          Departments.select(Departments.name, Departments.location)
            .where(Departments.id.eq(1)))
        .exec(conn)

      result = Departments.select(Focus.count(Departments.id)).where(Departments.name.eq("tech")).query_one(conn, Int64)
      assert_equal 2, result
    end
  end
end
