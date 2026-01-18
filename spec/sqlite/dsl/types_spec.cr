require "../../sqlite_spec_helper"

describe Focus::SQLite::Dsl::Types do
  describe ".date" do
    it "supports separate args" do
      date = Focus::SQLite.date(2026, 1, 17)

      visitor = Focus::SQLiteFormatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("DATE(?)")
      visitor.parameters.should eq(["2026-01-17"])
    end

    it "supports time" do
      time = Time.utc
      date = Focus::SQLite.date(time)

      visitor = Focus::SQLiteFormatter.new
      date.accept(visitor)
      visitor.to_sql.should eq("DATE(?)")
      visitor.parameters.should eq([time])
    end
  end

  # describe ".timestamp" do
  #   it "supports separate args" do
  #     timestamp = Focus::SQLite.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30)

  #     visitor = Focus::SQLiteFormatter.new
  #     timestamp.accept(visitor)
  #     visitor.to_sql.should eq("CAST(? AS TIMESTAMP)")
  #     visitor.parameters.should eq(["2026-01-17 10:25:30"])
  #   end

  #   it "supports separate args with nanoseconds" do
  #     timestamp = Focus::SQLite.timestamp(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 100)

  #     visitor = Focus::SQLiteFormatter.new
  #     timestamp.accept(visitor)
  #     visitor.to_sql.should eq("CAST(? AS TIMESTAMP)")
  #     visitor.parameters.should eq(["2026-01-17 10:25:30.0000001"])
  #   end

  #   it "supports time" do
  #     time = Time.utc
  #     timestamp = Focus::SQLite.timestamp(time)

  #     visitor = Focus::SQLiteFormatter.new
  #     timestamp.accept(visitor)
  #     visitor.to_sql.should eq("CAST(? AS TIMESTAMP)")
  #     visitor.parameters.should eq([time])
  #   end
  # end

  # describe ".timestamp_tz" do
  #   it "supports separate args" do
  #     timestamp_tz = Focus::SQLite.timestamp_tz(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 0, time_zone: "GMT")

  #     visitor = Focus::SQLiteFormatter.new
  #     timestamp_tz.accept(visitor)
  #     visitor.to_sql.should eq("CAST(? AS TIMESTAMPTZ)")
  #     visitor.parameters.should eq(["2026-01-17 10:25:30 GMT"])
  #   end

  #   it "supports time" do
  #     time = Time.utc
  #     timestamp_tz = Focus::SQLite.timestamp_tz(time)

  #     visitor = Focus::SQLiteFormatter.new
  #     timestamp_tz.accept(visitor)
  #     visitor.to_sql.should eq("CAST(? AS TIMESTAMPTZ)")
  #     visitor.parameters.should eq([time])
  #   end
  # end
end
