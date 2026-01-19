require "../../pg_spec_helper"

describe Focus::PG::Dsl::Types do
  describe ".date" do
    it "supports separate args" do
      date = Focus::PG.date(2026, 1, 17)

      visitor = Focus::PG::Formatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS DATE)")
      visitor.parameters.should eq(["2026-01-17"])
    end

    it "supports time" do
      time = Time.utc
      date = Focus::PG.date(time)

      visitor = Focus::PG::Formatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS DATE)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".timestamp" do
    it "supports separate args" do
      timestamp = Focus::PG.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30)

      visitor = Focus::PG::Formatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq(["2026-01-17 10:25:30"])
    end

    it "supports separate args with nanoseconds" do
      timestamp = Focus::PG.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 100)

      visitor = Focus::PG::Formatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq(["2026-01-17 10:25:30.0000001"])
    end

    it "supports time" do
      time = Time.utc
      timestamp = Focus::PG.timestamp(time)

      visitor = Focus::PG::Formatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMP)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".timestamp_tz" do
    it "supports separate args" do
      timestamp_tz = Focus::PG.timestamp_tz(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 0, time_zone: "GMT")

      visitor = Focus::PG::Formatter.new
      timestamp_tz.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMPTZ)")
      visitor.parameters.should eq(["2026-01-17 10:25:30 GMT"])
    end

    it "supports time" do
      time = Time.utc
      timestamp_tz = Focus::PG.timestamp_tz(time)

      visitor = Focus::PG::Formatter.new
      timestamp_tz.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIMESTAMPTZ)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".time" do
    it "supports separate args" do
      time = Focus::PG.time(10, 25, 30)

      visitor = Focus::PG::Formatter.new
      time.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIME)")
      visitor.parameters.should eq(["10:25:30"])
    end

    it "supports separate args with nanoseconds" do
      time = Focus::PG.time(10, 25, 30, nanoseconds: 100)

      visitor = Focus::PG::Formatter.new
      time.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS TIME)")
      visitor.parameters.should eq(["10:25:30.0000001"])
    end
  end

  describe ".interval" do
    it "supports Time::Span" do
      span = Time::Span.new(days: 1, hours: 2, minutes: 30, seconds: 45)
      interval = Focus::PG.interval(span)

      visitor = Focus::PG::Formatter.new
      interval.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["1 day 2 hours 30 minutes 45 seconds"])
    end

    it "supports Time::Span with plural units" do
      span = Time::Span.new(days: 3, hours: 5)
      interval = Focus::PG.interval(span)

      visitor = Focus::PG::Formatter.new
      interval.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["3 days 5 hours"])
    end

    it "supports string format" do
      interval = Focus::PG.interval("1 day 2 hours")

      visitor = Focus::PG::Formatter.new
      interval.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["1 day 2 hours"])
    end

    it "handles zero span" do
      span = Time::Span.new(nanoseconds: 0)
      interval = Focus::PG.interval(span)

      visitor = Focus::PG::Formatter.new
      interval.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["0 seconds"])
    end
  end

  describe "timestamp + interval arithmetic" do
    it "supports timestamp + interval" do
      timestamp = Focus::PG.timestamp_column("created_at")
      interval = Focus::PG.interval("1 day")
      result = timestamp.add(interval)

      visitor = Focus::PG::Formatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("created_at + CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["1 day"])
    end

    it "supports timestamp - interval" do
      timestamp = Focus::PG.timestamp_column("created_at")
      interval = Focus::PG.interval("2 hours")
      result = timestamp.sub(interval)

      visitor = Focus::PG::Formatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("created_at - CAST($1 AS INTERVAL)")
      visitor.parameters.should eq(["2 hours"])
    end

    it "supports interval + interval" do
      interval1 = Focus::PG.interval("1 day")
      interval2 = Focus::PG.interval("2 hours")
      result = interval1.add(interval2)

      visitor = Focus::PG::Formatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CAST($1 AS INTERVAL) + CAST($2 AS INTERVAL)")
      visitor.parameters.should eq(["1 day", "2 hours"])
    end
  end
end
