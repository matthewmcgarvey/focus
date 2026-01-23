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
      Departments.select(Departments.name).where(Departments.id.eq(Focus::PG.int32(1))).query_one(conn, String).should eq("tech")

      Departments.update
        .set(Departments.name, Departments.select(Departments.name).where(Departments.id.eq(Focus::PG.int32(2))))
        .where(Departments.id.eq(Focus::PG.int32(1)))
        .exec(conn)

      Departments.select(Departments.name).where(Departments.id.eq(Focus::PG.int32(1))).query_one(conn, String).should eq("finance")
    end
  end

  it "updates with returning clause" do
    in_transaction do |conn|
      ids = Departments.update.set(Departments.name, "foo").returning(Departments.id).query_all(conn, Int32)

      ids.size.should be > 0
      ids.should eq(Departments.select(Departments.id).distinct.where(Departments.name.eq(Focus::PG.string("foo"))).query_all(conn, Int32))
    end
  end

  it "updates date column" do
    in_transaction do |conn|
      Employees.update.set(Employees.hire_date, Time.utc(2026, 1, 10)).where(Employees.id.eq(Focus::PG.int32(1))).exec(conn)

      result = Employees.select(Employees.hire_date).where(Employees.id.eq(Focus::PG.int32(1))).query_one(conn, Time)
      result.should eq(Time.utc(2026, 1, 10))
    end
  end

  it "updates with from clause" do
    in_transaction do |conn|
      stmt = Employees.update
        .set(Employees.job, Departments.name)
        .from(Departments)
        .where(Employees.department_id.eq(Departments.id).and(Employees.id.eq(Focus::PG.int32(1))))

      stmt.to_sql.should eq(formatted(<<-SQL))
        UPDATE employees SET job = departments.name
        FROM departments
        WHERE (employees.department_id = departments.id) AND (employees.id = $1)
      SQL
      stmt.exec(conn)

      Employees.select(Employees.job).where(Employees.id.eq(Focus::PG.int32(1))).query_one(conn, String).should eq("tech")
    end
  end
end
