require "../sqlite_spec_helper"

describe "SQLite Insert" do
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
            .where(Departments.id.eq(Focus::SQLite.int32(1))))
        .exec(conn)

      result = Departments.select(Focus::SQLite.count(Departments.id)).where(Departments.name.eq(Focus::SQLite.string("tech"))).query_one(conn, Int64)
      result.should eq(2)
    end
  end

  context "on conflict" do
    it "works with no passed columns" do
      in_transaction do |conn|
        stmt = Departments.insert(Departments.id, Departments.name, Departments.location)
          .values(1, "marketing", "Hong Kong")
          .on_conflict
          .do_nothing
        stmt.to_sql.should eq(formatted(<<-SQL))
          INSERT INTO departments (id, name, location)
          VALUES (?, ?, ?)
          ON CONFLICT DO NOTHING
        SQL
        stmt.exec(conn)

        department_names = Departments.select(Departments.name).query_all(conn, as: String)
        department_names.sort.should eq(["tech", "finance"].sort)
      end
    end
  end
end
