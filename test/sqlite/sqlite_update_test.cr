require "./sqlite_test_base"

class SQLiteUpdateTest < SQLiteTestBase
  def test_simple_update
    Departments.update
      .set(Departments.name, "foo")
      .exec(database)

    result = Focus.select(Departments.name)
      .from(Departments)
      .group_by(Departments.name)
      .query_all(database, String)
    assert_equal ["foo"], result
  end
end
