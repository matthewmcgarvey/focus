require "../../pg_spec_helper"

describe Focus::PG::Dsl::ArrayTypes do
  describe ".bool_array" do
    it "works" do
      bool_arr = Focus::PG.bool_array([true, false, true])

      visitor = Focus::PG::Formatter.new
      bool_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2, $3] AS BOOLEAN[])")
      visitor.parameters.should eq([true, false, true])
    end
  end

  describe ".string_array" do
    it "works" do
      string_arr = Focus::PG.string_array(["hello", "goodbye"])

      visitor = Focus::PG::Formatter.new
      string_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2] AS TEXT[])")
      visitor.parameters.should eq(["hello", "goodbye"])
    end
  end

  describe ".int32_array" do
    it "works" do
      int_arr = Focus::PG.int32_array([1, 2, 3] of Int32)

      visitor = Focus::PG::Formatter.new
      int_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2, $3] AS INTEGER[])")
      visitor.parameters.should eq([1, 2, 3] of Int32)
    end
  end

  describe ".int64_array" do
    it "works" do
      int_arr = Focus::PG.int64_array([1, 2, 3] of Int64)

      visitor = Focus::PG::Formatter.new
      int_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2, $3] AS BIGINT[])")
      visitor.parameters.should eq([1, 2, 3] of Int64)

      result = Focus::PG.select(int_arr).query_one(PG_DATABASE, Array(Int64))
      result.should eq([1, 2, 3] of Int64)
    end
  end

  describe ".float32_array" do
    it "works" do
      float_arr = Focus::PG.float32_array([1.3, 2.4, 3.5] of Float32)

      visitor = Focus::PG::Formatter.new
      float_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2, $3] AS REAL[])")
      visitor.parameters.should eq([1.3, 2.4, 3.5] of Float32)
    end
  end

  describe ".float64_array" do
    it "works" do
      float_arr = Focus::PG.float64_array([1.3, 2.4, 3.5] of Float64)

      visitor = Focus::PG::Formatter.new
      float_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2, $3] AS DOUBLE[])")
      visitor.parameters.should eq([1.3, 2.4, 3.5] of Float64)
    end
  end

  describe ".date_array" do
    it "works" do
      time1 = Time.utc(2025, 10, 30)
      time2 = Time.utc(2026, 1, 20)
      date_arr = Focus::PG.date_array([time1, time2] of Time)

      visitor = Focus::PG::Formatter.new
      date_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2] AS DATE[])")
      visitor.parameters.should eq([time1, time2] of Time)
    end
  end

  describe ".time_array" do
    it "works" do
      time1 = Time.utc(2025, 10, 30)
      time2 = Time.utc(2026, 1, 20)
      time_arr = Focus::PG.time_array([time1, time2] of Time)

      visitor = Focus::PG::Formatter.new
      time_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2] AS TIME WITHOUT TIME ZONE[])")
      visitor.parameters.should eq([time1, time2] of Time)
    end
  end

  describe ".timestamp_tz_array" do
    it "works" do
      time1 = Time.utc(2025, 10, 30)
      time2 = Time.utc(2026, 1, 20)
      timestamp_arr = Focus::PG.timestamp_tz_array([time1, time2] of Time)

      visitor = Focus::PG::Formatter.new
      timestamp_arr.accept(visitor)
      visitor.to_sql.should eq("CAST(ARRAY[$1, $2] AS TIMESTAMP WITH TIME ZONE[])")
      visitor.parameters.should eq([time1, time2] of Time)
    end
  end
end
