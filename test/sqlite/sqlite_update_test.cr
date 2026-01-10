require "./sqlite_test_base"

class SQLiteUpdateTest < SQLiteTestBase
  def test_simple_update
    in_transaction do |conn|
      Departments.update
        .set(Departments.name, "foo")
        .exec(conn)

      result = Departments.select(Departments.name)
        .group_by(Departments.name)
        .query_all(conn, String)
      assert_equal ["foo"], result
    end
  end

  def test_set_from_select
    in_transaction do |conn|
      assert_equal "tech", Departments.select(Departments.name).where(Departments.id.eq(1)).query_one(conn, String)

      Departments.update
        .set(Departments.name, Departments.select(Departments.name).where(Departments.id.eq(2)))
        .where(Departments.id.eq(1))
        .exec(conn)

      assert_equal "finance", Departments.select(Departments.name).where(Departments.id.eq(1)).query_one(conn, String)
    end
  end

  def test_returning
    in_transaction do |conn|
      ids = Departments.update.set(Departments.name, "foo").returning(Departments.id).query_all(conn, Int32)

      assert ids.size > 0
      assert_equal ids, Departments.select(Departments.id).distinct.where(Departments.name.eq("foo")).query_all(conn, Int32)
    end
  end
end
