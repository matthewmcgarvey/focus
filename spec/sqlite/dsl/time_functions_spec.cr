require "../../sqlite_spec_helper"

describe Focus::SQLite::Dsl::TimeFunctions do
  describe ".current_date" do
    it "does not include parenthesis" do
      expr = Focus::SQLite.current_date

      visitor = Focus::SQLite::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_DATE")
    end
  end

  describe ".current_time" do
    it "does not include parenthesis" do
      expr = Focus::SQLite.current_time

      visitor = Focus::SQLite::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_TIME")
    end
  end

  describe ".current_timestamp" do
    it "does not include parenthesis" do
      expr = Focus::SQLite.current_timestamp

      visitor = Focus::SQLite::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("CURRENT_TIMESTAMP")
    end
  end
end
