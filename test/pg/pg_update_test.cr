require "./pg_test_base"

class PGUpdateTest < PGTestBase
  def test_simple_update
    Departments.update
      .set(Departments.name, "foo")
      .exec(database)

    result = Departments.select(Departments.name)
      .group_by(Departments.name)
      .query_all(database, String)
    assert_equal ["foo"], result
  end
end
