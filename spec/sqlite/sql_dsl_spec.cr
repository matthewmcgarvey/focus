require "../sqlite_spec_helper"

describe "Focus::SQLite.sql DSL" do
  it "allows calling DSL methods without Focus::SQLite prefix" do
    stmt = Focus::SQLite.sql do
      Employees.select(Employees.name)
        .where(Employees.id.eq(int32(1)))
    end

    stmt.to_sql.should eq(%(SELECT employees.name FROM employees WHERE employees.id = ?))
    stmt.query_one(SQLITE_DATABASE, as: String).should eq("vince")
  end

  it "allows using string literals without prefix" do
    stmt = Focus::SQLite.sql do
      Employees.select(Employees.name)
        .where(Employees.name.eq(string("vince")))
    end

    stmt.to_sql.should eq(%(SELECT employees.name FROM employees WHERE employees.name = ?))
    stmt.query_one(SQLITE_DATABASE, as: String).should eq("vince")
  end

  it "allows using aggregation functions without prefix" do
    stmt = Focus::SQLite.sql do
      Employees.select(count(Employees.id))
    end

    stmt.to_sql.should eq(%(SELECT COUNT(employees.id) FROM employees))
    stmt.query_one(SQLITE_DATABASE, as: Int32).should eq(4)
  end

  it "allows using cast without prefix" do
    stmt = Focus::SQLite.sql do
      Employees.select(Employees.name)
        .where(Employees.id.eq(cast(string("1")).as_integer))
    end

    stmt.to_sql.should eq(%(SELECT employees.name FROM employees WHERE employees.id = CAST(? AS INTEGER)))
    stmt.query_one(SQLITE_DATABASE, as: String).should eq("vince")
  end
end
