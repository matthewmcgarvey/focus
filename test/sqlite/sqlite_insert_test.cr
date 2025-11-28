require "./sqlite_test_base"

class SQLiteInsertTest < SQLiteTestBase
  def test_simple_insert
    ids = Departments.insert(Departments.name, Departments.location)
      .values("r&d", "basement")
      .values("hr", "hawaii")
      .returning(Departments.id)
      .query_all(database, as: Int32)
    assert_equal 2, ids.size

    result = Focus.select(Departments.name).from(Departments).query_all(database, String)
    assert_equal ["tech", "finance", "r&d", "hr"], result
  end
end
