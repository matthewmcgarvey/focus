require "../pg_spec_helper"

describe "PG Insert" do
  it "inserts with simple values" do
    in_transaction do |conn|
      ids = Departments.insert(Departments.name, Departments.location)
        .values("r&d", "basement")
        .values("hr", "hawaii")
        .returning(Departments.id)
        .query_all(conn, as: Int32)
      ids.size.should eq(2)

      result = Departments.select(Departments.name).query_all(conn, String)
      result.should eq(["tech", "finance", "r&d", "hr"])
    end
  end

  it "inserts from query" do
    in_transaction do |conn|
      Departments.insert(Departments.name, Departments.location)
        .query(
          Departments.select(Departments.name, Departments.location)
            .where(Departments.id.eq(1)))
        .exec(conn)

      result = Departments.select(Focus.count(Departments.id)).where(Departments.name.eq("tech")).query_one(conn, Int64)
      result.should eq(2)
    end
  end
end
