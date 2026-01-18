require "../../pg_spec_helper"

describe Focus::PG::Dsl::Types do
  describe ".date" do
    it "supports separate args" do
      date = Focus::PG.date(2026, 1, 17)

      visitor = Focus::PGFormatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS DATE)")
      visitor.parameters.should eq(["2026-01-17"])
    end

    it "supports time" do
      time = Time.utc
      date = Focus::PG.date(time)

      visitor = Focus::PGFormatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS DATE)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".timestamp" do
    it "supports separate args" do
      timestamp = Focus::PG.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30)

      visitor = Focus::PGFormatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq(["2026-01-17 10:25:30"])
    end

    it "supports separate args with nanoseconds" do
      timestamp = Focus::PG.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 100)

      visitor = Focus::PGFormatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq(["2026-01-17 10:25:30.0000001"])
    end

    it "supports time" do
      time = Time.utc
      timestamp = Focus::PG.timestamp(time)

      visitor = Focus::PGFormatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".timestamp_tz" do
    it "supports separate args" do
      timestamp_tz = Focus::PG.timestamp_tz(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 0, time_zone: "GMT")

      visitor = Focus::PGFormatter.new
      timestamp_tz.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMPTZ)")
      visitor.parameters.should eq(["2026-01-17 10:25:30 GMT"])
    end

    it "supports time" do
      time = Time.utc
      timestamp_tz = Focus::PG.timestamp_tz(time)

      visitor = Focus::PGFormatter.new
      timestamp_tz.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMPTZ)")
      visitor.parameters.should eq([time])
    end
  end
end
