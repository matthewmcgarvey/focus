require "../pg_spec_helper"

describe "PG Delete" do
  it "deletes with simple where clause" do
    in_transaction do |conn|
      Employees.select(Employees.id).where(Employees.id.eq(Focus::PG.int32(1))).query_one?(conn, Int32).should_not be_nil

      Employees.delete.where(Employees.id.eq(Focus::PG.int32(1))).exec(conn)

      Employees.select(Employees.id).where(Employees.id.eq(Focus::PG.int32(1))).query_one?(conn, Int32).should be_nil
    end
  end

  it "deletes with returning clause" do
    in_transaction do |conn|
      ids = Employees.delete.returning(Employees.id).query_all(conn, Int32)
      ids.size.should be > 0

      Employees.select(Focus::PG.count(Employees.id)).query_one(conn, Int64).should eq(0)
    end
  end

  it "deletes with using clause" do
    in_transaction do |conn|
      stmt = Employees.delete
        .using(Departments)
        .where(Employees.department_id.eq(Departments.id).and(Departments.name.eq(Focus::PG.string("tech"))))

      stmt.to_sql.should eq(formatted(<<-SQL))
        DELETE FROM employees
        USING departments
        WHERE (employees.department_id = departments.id) AND (departments.name = $1)
      SQL
      stmt.exec(conn)

      Employees.select(Focus::PG.count(Employees.id)).query_one(conn, Int64).should eq(2)
    end
  end
end
