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

  describe ".datetime" do
    it "supports separate args" do
      datetime = Focus::SQLite.datetime(2026, 1, 17, hour: 10, minute: 25, second: 30)

      visitor = Focus::SQLiteFormatter.new
      datetime.accept(visitor)
      visitor.to_sql.should eq("DATETIME(?)")
      visitor.parameters.should eq(["2026-01-17 10:25:30"])
    end

    it "supports separate args with nanoseconds" do
      datetime = Focus::SQLite.datetime(2026, 1, 17, hour: 10, minute: 25, second: 30, nanoseconds: 100)

      visitor = Focus::SQLiteFormatter.new
      datetime.accept(visitor)
      visitor.to_sql.should eq("DATETIME(?)")
      visitor.parameters.should eq(["2026-01-17 10:25:30.0000001"])
    end

    it "supports time" do
      time = Time.utc
      timestamp = Focus::SQLite.datetime(time)

      visitor = Focus::SQLiteFormatter.new
      timestamp.accept(visitor)
      visitor.to_sql.should eq("DATETIME(?)")
      visitor.parameters.should eq([time])
    end
  end

  describe ".time" do
    it "supports separate args" do
      time = Focus::SQLite.time(10, 25, 30)

      visitor = Focus::SQLiteFormatter.new
      time.accept(visitor)
      visitor.to_sql.should eq("TIME(?)")
      visitor.parameters.should eq(["10:25:30"])
    end

    it "supports separate args with nanoseconds" do
      time = Focus::SQLite.time(10, 25, 30, nanoseconds: 100)

      visitor = Focus::SQLiteFormatter.new
      time.accept(visitor)
      visitor.to_sql.should eq("TIME(?)")
      visitor.parameters.should eq(["10:25:30.0000001"])
    end
  end
end
