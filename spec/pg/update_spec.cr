require "../pg_spec_helper"

describe "PG Update" do
  it "updates with simple set" do
    in_transaction do |conn|
      Departments.update
        .set(Departments.name, "foo")
        .exec(conn)

      result = Departments.select(Departments.name)
        .group_by(Departments.name)
        .query_all(conn, String)
      result.should eq(["foo"])
    end
  end

  it "sets from select subquery" do
    in_transaction do |conn|
      Departments.select(Departments.name).where(Departments.id.eq(1)).query_one(conn, String).should eq("tech")

      Departments.update
        .set(Departments.name, Departments.select(Departments.name).where(Departments.id.eq(2)))
        .where(Departments.id.eq(1))
        .exec(conn)

      Departments.select(Departments.name).where(Departments.id.eq(1)).query_one(conn, String).should eq("finance")
    end
  end

  it "updates with returning clause" do
    in_transaction do |conn|
      ids = Departments.update.set(Departments.name, "foo").returning(Departments.id).query_all(conn, Int32)

      ids.size.should be > 0
      ids.should eq(Departments.select(Departments.id).distinct.where(Departments.name.eq("foo")).query_all(conn, Int32))
    end
  end
end
