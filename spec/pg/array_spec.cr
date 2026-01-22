require "../pg_spec_helper"

describe Focus::ArrayExpression do
  describe "#contains" do
    it "checks if array contains all elements of another array" do
      stmt = Employees.select(Employees.name)
        .where(Employees.skills.contains(Focus::PG.string_array(["crystal", "sql"])))
      stmt.to_sql.should eq("SELECT employees.name FROM employees WHERE employees.skills @> CAST(ARRAY[$1, $2] AS TEXT[])")
      stmt.query_all(PG_DATABASE, as: String).should eq(["vince"])
    end
  end

  describe "#is_contained_by" do
    it "checks if array is contained by another array" do
      stmt = Employees.select(Employees.name)
        .where(Employees.skills.is_contained_by(Focus::PG.string_array(["python", "java", "go"])))
      stmt.to_sql.should eq("SELECT employees.name FROM employees WHERE employees.skills <@ CAST(ARRAY[$1, $2, $3] AS TEXT[])")
      stmt.query_all(PG_DATABASE, as: String).should eq(["marry"])
    end
  end

  describe "#overlap" do
    it "checks if arrays have any elements in common" do
      stmt = Employees.select(Employees.name)
        .where(Employees.skills.overlap(Focus::PG.string_array(["ruby", "excel"])))
        .order_by(Employees.name.asc)
      stmt.to_sql.should eq("SELECT employees.name FROM employees WHERE employees.skills && CAST(ARRAY[$1, $2] AS TEXT[]) ORDER BY employees.name ASC")
      stmt.query_all(PG_DATABASE, as: String).should eq(["penny", "vince"])
    end
  end

  describe "#concat" do
    it "concatenates two arrays" do
      stmt = Employees.select(Employees.skills.concat(Focus::PG.string_array(["go"])).aliased("all_skills"))
        .where(Employees.name.eq(Focus::PG.string("marry")))
      stmt.to_sql.should eq("SELECT employees.skills || CAST(ARRAY[$1] AS TEXT[]) AS all_skills FROM employees WHERE employees.name = $2")
      stmt.query_one(PG_DATABASE, as: Array(String)).should eq(["python", "go"])
    end
  end

  describe "#array_append" do
    it "appends an element to an array" do
      stmt = Employees.select(Employees.skills.array_append(Focus::PG.string("wasting time")).aliased("skillz"))
        .where(Employees.name.eq(Focus::PG.string("marry")))
        .limit(1)
      stmt.to_sql.should eq("SELECT ARRAY_APPEND(employees.skills, $1) AS skillz FROM employees WHERE employees.name = $2 LIMIT $3")
      stmt.query_one(PG_DATABASE, as: Array(String)).should eq(["python", "wasting time"])
    end
  end
end
