require "../../pg_spec_helper"

describe Focus::PG::Dsl::Aggregation do
  describe ".array_agg" do
    it "works" do
      query = Employees.select(Focus::PG.array_agg(Employees.id))

      query.to_sql.should eq("SELECT ARRAY_AGG(employees.id) FROM employees")
      result = query.query_one(PG_DATABASE, Array(Int32))
      result.should eq([1, 2, 3, 4])
    end
  end
end
