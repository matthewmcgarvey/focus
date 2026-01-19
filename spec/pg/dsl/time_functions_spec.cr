require "../../pg_spec_helper"

describe Focus::PG::Dsl::TimeFunctions do
  describe ".current_date" do
    it "does not include parenthesis" do
      expr = Focus::PG.current_date

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_DATE")
    end
  end

  describe ".current_time" do
    it "does not include parenthesis" do
      expr = Focus::PG.current_time

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_TIME")
    end
  end

  describe ".current_timestamp" do
    it "does not include parenthesis" do
      expr = Focus::PG.current_timestamp

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_TIMESTAMP")
    end
  end

  describe ".now" do
    it "does include parenthesis" do
      expr = Focus::PG.now

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("NOW()")
    end
  end
end
