require "../../spec_helper"

# Test module that extends StringFunctions to allow calling them
module TestStringFunctions
  extend Focus::Dsl::StringFunctions
  extend Focus::Dsl::Columns
end

describe Focus::Dsl::StringFunctions do
  describe "#length" do
    it "generates LENGTH for string expression" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.length(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LENGTH(name)")
    end
  end

  describe "#lower" do
    it "generates LOWER for string expression" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.lower(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LOWER(name)")
    end
  end

  describe "#upper" do
    it "generates UPPER for string expression" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.upper(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("UPPER(name)")
    end
  end

  describe "#ltrim" do
    it "generates LTRIM without chars" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.ltrim(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LTRIM(name)")
    end

    it "generates LTRIM with chars" do
      col = Focus::StringColumn.new("name")
      chars = Focus::StringColumn.new("trim_chars")
      result = TestStringFunctions.ltrim(col, chars)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("LTRIM(name, trim_chars)")
    end
  end

  describe "#rtrim" do
    it "generates RTRIM without chars" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.rtrim(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("RTRIM(name)")
    end

    it "generates RTRIM with chars" do
      col = Focus::StringColumn.new("name")
      chars = Focus::StringColumn.new("trim_chars")
      result = TestStringFunctions.rtrim(col, chars)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("RTRIM(name, trim_chars)")
    end
  end

  describe "#trim" do
    it "generates TRIM without chars" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.trim(col)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("TRIM(name)")
    end

    it "generates TRIM with chars" do
      col = Focus::StringColumn.new("name")
      chars = Focus::StringColumn.new("trim_chars")
      result = TestStringFunctions.trim(col, chars)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("TRIM(name, trim_chars)")
    end
  end

  describe "#substr" do
    it "generates SUBSTR with start" do
      col = Focus::StringColumn.new("name")
      start = Focus::IntColumn(Int32).new("start_pos")
      result = TestStringFunctions.substr(col, start)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("SUBSTR(name, start_pos)")
    end

    it "generates SUBSTR with start and length" do
      col = Focus::StringColumn.new("name")
      start = Focus::IntColumn(Int32).new("start_pos")
      len = Focus::IntColumn(Int32).new("len")
      result = TestStringFunctions.substr(col, start, len)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("SUBSTR(name, start_pos, len)")
    end
  end

  describe "#replace" do
    it "generates REPLACE for string expressions" do
      col = Focus::StringColumn.new("name")
      from = Focus::StringColumn.new("old_val")
      to = Focus::StringColumn.new("new_val")
      result = TestStringFunctions.replace(col, from, to)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("REPLACE(name, old_val, new_val)")
    end
  end

  describe "#concat" do
    it "generates CONCAT for multiple string expressions" do
      col1 = Focus::StringColumn.new("first_name")
      col2 = Focus::StringColumn.new("last_name")
      result = TestStringFunctions.concat(col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CONCAT(first_name, last_name)")
    end

    it "generates CONCAT for three expressions" do
      col1 = Focus::StringColumn.new("first")
      col2 = Focus::StringColumn.new("middle")
      col3 = Focus::StringColumn.new("last")
      result = TestStringFunctions.concat(col1, col2, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CONCAT(first, middle, last)")
    end
  end

  describe "#concat_ws" do
    it "generates CONCAT_WS with separator and expressions" do
      sep = Focus::StringColumn.new("separator")
      col1 = Focus::StringColumn.new("first_name")
      col2 = Focus::StringColumn.new("last_name")
      result = TestStringFunctions.concat_ws(sep, col1, col2)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CONCAT_WS(separator, first_name, last_name)")
    end

    it "generates CONCAT_WS with three values" do
      sep = Focus::StringColumn.new("sep")
      col1 = Focus::StringColumn.new("a")
      col2 = Focus::StringColumn.new("b")
      col3 = Focus::StringColumn.new("c")
      result = TestStringFunctions.concat_ws(sep, col1, col2, col3)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("CONCAT_WS(sep, a, b, c)")
    end
  end

  describe "function chaining" do
    it "can use function result in another expression" do
      col = Focus::StringColumn.new("name")
      lower_result = TestStringFunctions.lower(col)
      comparison = lower_result.eq(Focus::StringLiteral.new("test"))

      visitor = Focus::SqlFormatter.new
      comparison.accept(visitor)
      visitor.to_sql.should eq("(LOWER(name) = ?)")
    end

    it "can nest function calls" do
      col = Focus::StringColumn.new("name")
      result = TestStringFunctions.upper(TestStringFunctions.trim(col))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("UPPER(TRIM(name))")
    end

    it "can use length result in comparison" do
      col = Focus::StringColumn.new("name")
      len_result = TestStringFunctions.length(col)
      comparison = len_result.greater_than(Focus::IntLiteral(Int64).new(10))

      visitor = Focus::SqlFormatter.new
      comparison.accept(visitor)
      visitor.to_sql.should eq("(LENGTH(name) > ?)")
    end
  end
end
