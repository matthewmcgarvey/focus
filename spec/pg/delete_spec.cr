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
end
