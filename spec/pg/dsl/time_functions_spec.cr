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

  describe ".age" do
    context "with single timestamp argument" do
      it "generates AGE function for TimestampExpression" do
        ts = Focus::PG.timestamp(2020, 1, 15, 10, 30, 0)
        age_expr = Focus::PG.age(ts)

        stmt = Focus::PG.select(age_expr.aliased("age"))
        stmt.to_sql.should eq("SELECT AGE(CAST($1 AS TIMESTAMP)) AS age")
        result = stmt.query_one(PG_DATABASE, as: PG::Interval)
        result.should be_a(PG::Interval)
      end

      it "generates AGE function for TimestampTzExpression" do
        ts = Focus::PG.timestamp_tz(2020, 1, 15, 10, 30, 0, 0, "UTC")
        age_expr = Focus::PG.age(ts)

        stmt = Focus::PG.select(age_expr.aliased("age"))
        stmt.to_sql.should eq("SELECT AGE(CAST($1 AS TIMESTAMPTZ)) AS age")
        result = stmt.query_one(PG_DATABASE, as: PG::Interval)
        result.should be_a(PG::Interval)
      end
    end

    context "with two timestamp arguments" do
      it "generates AGE function for two TimestampExpressions" do
        ts1 = Focus::PG.timestamp(2024, 6, 15, 10, 30, 0)
        ts2 = Focus::PG.timestamp(2020, 1, 15, 10, 30, 0)
        age_expr = Focus::PG.age(ts1, ts2)

        stmt = Focus::PG.select(age_expr.aliased("age"))
        stmt.to_sql.should eq("SELECT AGE(CAST($1 AS TIMESTAMP), CAST($2 AS TIMESTAMP)) AS age")
        result = stmt.query_one(PG_DATABASE, as: PG::Interval)
        result.months.should eq(53) # 4 years and 5 months = 53 months
      end

      it "generates AGE function for two TimestampTzExpressions" do
        ts1 = Focus::PG.timestamp_tz(2024, 6, 15, 10, 30, 0, 0, "UTC")
        ts2 = Focus::PG.timestamp_tz(2020, 1, 15, 10, 30, 0, 0, "UTC")
        age_expr = Focus::PG.age(ts1, ts2)

        stmt = Focus::PG.select(age_expr.aliased("age"))
        stmt.to_sql.should eq("SELECT AGE(CAST($1 AS TIMESTAMPTZ), CAST($2 AS TIMESTAMPTZ)) AS age")
        result = stmt.query_one(PG_DATABASE, as: PG::Interval)
        result.months.should eq(53) # 4 years and 5 months = 53 months
      end
    end
  end
end
