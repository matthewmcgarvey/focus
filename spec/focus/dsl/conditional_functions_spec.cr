require "../../spec_helper"

# Test module that extends ConditionalFunctions to allow calling them
module TestConditionalFunctions
  extend Focus::Dsl::ConditionalFunctions
  extend Focus::Dsl::Columns
end

describe Focus::Dsl::ConditionalFunctions do
  describe "#coalesce" do
    it "generates COALESCE for int expressions" do
      col1 = Focus::IntColumn(Int32).new("value1")
      col2 = Focus::IntColumn(Int32).new("value2")
      result = TestConditionalFunctions.coalesce(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(value1, value2)")
    end

    it "generates COALESCE for multiple int expressions" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      col3 = Focus::IntColumn(Int32).new("c")
      result = TestConditionalFunctions.coalesce(col1, col2, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(a, b, c)")
    end

    it "generates COALESCE for float expressions" do
      col1 = Focus::FloatColumn(Float64).new("price1")
      col2 = Focus::FloatColumn(Float64).new("price2")
      result = TestConditionalFunctions.coalesce(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(price1, price2)")
    end

    it "generates COALESCE for string expressions" do
      col1 = Focus::StringColumn.new("name1")
      col2 = Focus::StringColumn.new("name2")
      result = TestConditionalFunctions.coalesce(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(name1, name2)")
    end

    it "generates COALESCE for bool expressions" do
      col1 = Focus::BoolColumn.new("active1")
      col2 = Focus::BoolColumn.new("active2")
      result = TestConditionalFunctions.coalesce(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(active1, active2)")
    end

    it "generates COALESCE for timestamp expressions" do
      col1 = Focus::TimestampTzColumn.new("created_at")
      col2 = Focus::TimestampTzColumn.new("updated_at")
      result = TestConditionalFunctions.coalesce(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(created_at, updated_at)")
    end
  end

  describe "#nullif" do
    it "generates NULLIF for int expressions" do
      col1 = Focus::IntColumn(Int32).new("value")
      col2 = Focus::IntColumn(Int32).new("default_value")
      result = TestConditionalFunctions.nullif(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("NULLIF(value, default_value)")
    end

    it "generates NULLIF for float expressions" do
      col1 = Focus::FloatColumn(Float64).new("price")
      col2 = Focus::FloatColumn(Float64).new("zero")
      result = TestConditionalFunctions.nullif(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("NULLIF(price, zero)")
    end

    it "generates NULLIF for string expressions" do
      col1 = Focus::StringColumn.new("name")
      col2 = Focus::StringColumn.new("empty")
      result = TestConditionalFunctions.nullif(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("NULLIF(name, empty)")
    end

    it "generates NULLIF for bool expressions" do
      col1 = Focus::BoolColumn.new("flag1")
      col2 = Focus::BoolColumn.new("flag2")
      result = TestConditionalFunctions.nullif(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("NULLIF(flag1, flag2)")
    end

    it "generates NULLIF for timestamp expressions" do
      col1 = Focus::TimestampTzColumn.new("timestamp1")
      col2 = Focus::TimestampTzColumn.new("timestamp2")
      result = TestConditionalFunctions.nullif(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("NULLIF(timestamp1, timestamp2)")
    end
  end

  describe "#greatest" do
    it "generates GREATEST for int expressions" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      result = TestConditionalFunctions.greatest(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(a, b)")
    end

    it "generates GREATEST for multiple int expressions" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      col3 = Focus::IntColumn(Int32).new("c")
      result = TestConditionalFunctions.greatest(col1, col2, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(a, b, c)")
    end

    it "generates GREATEST for float expressions" do
      col1 = Focus::FloatColumn(Float64).new("price1")
      col2 = Focus::FloatColumn(Float64).new("price2")
      result = TestConditionalFunctions.greatest(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(price1, price2)")
    end

    it "generates GREATEST for string expressions" do
      col1 = Focus::StringColumn.new("name1")
      col2 = Focus::StringColumn.new("name2")
      result = TestConditionalFunctions.greatest(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(name1, name2)")
    end

    it "generates GREATEST for timestamp expressions" do
      col1 = Focus::TimestampTzColumn.new("date1")
      col2 = Focus::TimestampTzColumn.new("date2")
      result = TestConditionalFunctions.greatest(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(date1, date2)")
    end
  end

  describe "#least" do
    it "generates LEAST for int expressions" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      result = TestConditionalFunctions.least(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LEAST(a, b)")
    end

    it "generates LEAST for multiple int expressions" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      col3 = Focus::IntColumn(Int32).new("c")
      result = TestConditionalFunctions.least(col1, col2, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LEAST(a, b, c)")
    end

    it "generates LEAST for float expressions" do
      col1 = Focus::FloatColumn(Float64).new("price1")
      col2 = Focus::FloatColumn(Float64).new("price2")
      result = TestConditionalFunctions.least(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LEAST(price1, price2)")
    end

    it "generates LEAST for string expressions" do
      col1 = Focus::StringColumn.new("name1")
      col2 = Focus::StringColumn.new("name2")
      result = TestConditionalFunctions.least(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LEAST(name1, name2)")
    end

    it "generates LEAST for timestamp expressions" do
      col1 = Focus::TimestampTzColumn.new("date1")
      col2 = Focus::TimestampTzColumn.new("date2")
      result = TestConditionalFunctions.least(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LEAST(date1, date2)")
    end
  end

  describe "function chaining" do
    it "can use coalesce result in another expression" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      coalesce_result = TestConditionalFunctions.coalesce(col1, col2)
      comparison = coalesce_result.greater_than(Focus::IntLiteral(Int32).new(10))

      visitor = Focus::SqlFormatter.new
      comparison.accept(visitor)
      visitor.to_sql.should eq("(COALESCE(a, b) > ?)")
    end

    it "can nest conditional function calls" do
      col1 = Focus::IntColumn(Int32).new("a")
      col2 = Focus::IntColumn(Int32).new("b")
      col3 = Focus::IntColumn(Int32).new("c")
      inner = TestConditionalFunctions.coalesce(col1, col2)
      result = TestConditionalFunctions.greatest(inner, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("GREATEST(COALESCE(a, b), c)")
    end

    it "can use nullif result in coalesce" do
      col1 = Focus::StringColumn.new("name")
      col2 = Focus::StringColumn.new("empty")
      col3 = Focus::StringColumn.new("default")
      nullif_result = TestConditionalFunctions.nullif(col1, col2)
      result = TestConditionalFunctions.coalesce(nullif_result, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("COALESCE(NULLIF(name, empty), default)")
    end
  end
end
