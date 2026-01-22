require "../../spec_helper"

# Test module that extends MathFunctions to allow calling them
module TestMathFunctions
  extend Focus::Dsl::MathFunctions
  extend Focus::Dsl::Columns
end

describe Focus::Dsl::MathFunctions do
  describe "#abs" do
    it "generates ABS for float expression" do
      col = Focus::FloatColumn(Float64).new("price")
      result = TestMathFunctions.abs(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("ABS(price)")
    end

    it "generates ABS for int expression" do
      col = Focus::IntColumn(Int32).new("quantity")
      result = TestMathFunctions.abs(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("ABS(quantity)")
    end
  end

  describe "#ceil" do
    it "generates CEIL for float expression" do
      col = Focus::FloatColumn(Float64).new("price")
      result = TestMathFunctions.ceil(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CEIL(price)")
    end
  end

  describe "#floor" do
    it "generates FLOOR for float expression" do
      col = Focus::FloatColumn(Float64).new("price")
      result = TestMathFunctions.floor(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("FLOOR(price)")
    end
  end

  describe "#round" do
    it "generates ROUND without precision" do
      col = Focus::FloatColumn(Float64).new("price")
      result = TestMathFunctions.round(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("ROUND(price)")
    end

    it "generates ROUND with precision" do
      col = Focus::FloatColumn(Float64).new("price")
      precision = Focus::IntColumn(Int32).new("decimals")
      result = TestMathFunctions.round(col, precision)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("ROUND(price, decimals)")
    end
  end

  describe "#trunc" do
    it "generates TRUNC without precision" do
      col = Focus::FloatColumn(Float64).new("price")
      result = TestMathFunctions.trunc(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("TRUNC(price)")
    end

    it "generates TRUNC with precision" do
      col = Focus::FloatColumn(Float64).new("price")
      precision = Focus::IntColumn(Int32).new("decimals")
      result = TestMathFunctions.trunc(col, precision)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("TRUNC(price, decimals)")
    end
  end

  describe "#pow" do
    it "generates POW for two numeric expressions" do
      base = Focus::FloatColumn(Float64).new("base")
      exponent = Focus::IntColumn(Int32).new("exp")
      result = TestMathFunctions.pow(base, exponent)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("POW(base, exp)")
    end
  end

  describe "#power" do
    it "generates POWER for two numeric expressions" do
      base = Focus::IntColumn(Int32).new("x")
      exponent = Focus::IntColumn(Int32).new("y")
      result = TestMathFunctions.power(base, exponent)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("POWER(x, y)")
    end
  end

  describe "#sqrt" do
    it "generates SQRT for numeric expression" do
      col = Focus::IntColumn(Int32).new("value")
      result = TestMathFunctions.sqrt(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("SQRT(value)")
    end
  end

  describe "#ln" do
    it "generates LN for numeric expression" do
      col = Focus::FloatColumn(Float64).new("value")
      result = TestMathFunctions.ln(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LN(value)")
    end
  end

  describe "#log" do
    it "generates LOG for single numeric expression" do
      col = Focus::FloatColumn(Float64).new("value")
      result = TestMathFunctions.log(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LOG(value)")
    end

    it "generates LOG with base and value" do
      base = Focus::IntColumn(Int32).new("base")
      value = Focus::FloatColumn(Float64).new("value")
      result = TestMathFunctions.log(base, value)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LOG(base, value)")
    end
  end

  describe "#sign" do
    it "generates SIGN for float expression" do
      col = Focus::FloatColumn(Float64).new("amount")
      result = TestMathFunctions.sign(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("SIGN(amount)")
    end

    it "generates SIGN for int expression" do
      col = Focus::IntColumn(Int32).new("amount")
      result = TestMathFunctions.sign(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("SIGN(amount)")
    end
  end

  describe "#pi" do
    it "generates PI()" do
      result = TestMathFunctions.pi

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("PI()")
    end
  end

  describe "function chaining" do
    it "can use function result in another expression" do
      col = Focus::FloatColumn(Float64).new("price")
      abs_result = TestMathFunctions.abs(col)
      comparison = abs_result.greater_than(Focus::FloatLiteral.new(10.0))

      visitor = Focus::SqlFormatter.new
      comparison.accept(visitor)
      visitor.to_sql.should eq("(ABS(price) > ?)")
    end

    it "can nest function calls" do
      col = Focus::FloatColumn(Float64).new("value")
      result = TestMathFunctions.abs(TestMathFunctions.floor(col))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("ABS(FLOOR(value))")
    end
  end
end
