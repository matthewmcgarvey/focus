require "../pg_spec_helper"

describe Focus::PG::LockStatement do
  context "ACCESS SHARE" do
    it "works" do
      query = Employees.lock.in_access_share
      query.to_sql.should eq("LOCK TABLE employees IN ACCESS SHARE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "ROW SHARE" do
    it "works" do
      query = Employees.lock.in_row_share
      query.to_sql.should eq("LOCK TABLE employees IN ROW SHARE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "ROW EXCLUSIVE" do
    it "works" do
      query = Employees.lock.in_row_exclusive
      query.to_sql.should eq("LOCK TABLE employees IN ROW EXCLUSIVE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "SHARE UPDATE EXCLUSIVE" do
    it "works" do
      query = Employees.lock.in_share_update_exclusive
      query.to_sql.should eq("LOCK TABLE employees IN SHARE UPDATE EXCLUSIVE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "SHARE" do
    it "works" do
      query = Employees.lock.in_share
      query.to_sql.should eq("LOCK TABLE employees IN SHARE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "SHARE ROW EXCLUSIVE" do
    it "works" do
      query = Employees.lock.in_share_row_exclusive
      query.to_sql.should eq("LOCK TABLE employees IN SHARE ROW EXCLUSIVE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "EXCLUSIVE" do
    it "works" do
      query = Employees.lock.in_exclusive
      query.to_sql.should eq("LOCK TABLE employees IN EXCLUSIVE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "ACCESS EXCLUSIVE" do
    it "works" do
      query = Employees.lock.in_access_exclusive
      query.to_sql.should eq("LOCK TABLE employees IN ACCESS EXCLUSIVE MODE")

      in_transaction { |conn| query.exec(conn) }
    end
  end

  context "NOWAIT" do
    it "works" do
      query = Employees.lock.in_access_exclusive.no_wait
      query.to_sql.should eq("LOCK TABLE employees IN ACCESS EXCLUSIVE MODE NOWAIT")

      in_transaction { |conn| query.exec(conn) }
    end
  end
end
