require "../../spec_helper"

describe Focus::JsonbColumn do
  describe "#eq" do
    it "generates equality comparison" do
      column = Focus::JsonbColumn.new("data")
      json_value = JSON.parse(%({"key": "value"}))
      literal = Focus::JsonbLiteral.new(json_value)
      result = column.eq(literal)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data = ?")
    end
  end

  describe "#not_eq" do
    it "generates inequality comparison" do
      column = Focus::JsonbColumn.new("data")
      json_value = JSON.parse(%({"key": "value"}))
      literal = Focus::JsonbLiteral.new(json_value)
      result = column.not_eq(literal)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data != ?")
    end
  end

  describe "#contains" do
    it "generates @> operator" do
      column = Focus::JsonbColumn.new("data")
      json_value = JSON.parse(%({"key": "value"}))
      literal = Focus::JsonbLiteral.new(json_value)
      result = column.contains(literal)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data @> ?")
    end
  end

  describe "#contained_by" do
    it "generates <@ operator" do
      column = Focus::JsonbColumn.new("data")
      json_value = JSON.parse(%({"key": "value", "other": 123}))
      literal = Focus::JsonbLiteral.new(json_value)
      result = column.contained_by(literal)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data <@ ?")
    end
  end

  describe "#has_key" do
    it "generates ? operator" do
      column = Focus::JsonbColumn.new("data")
      key = Focus::StringLiteral.new("key")
      result = column.has_key(key)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data ? ?")
    end
  end

  describe "#get" do
    it "generates -> operator with string key" do
      column = Focus::JsonbColumn.new("data")
      key = Focus::StringLiteral.new("key")
      result = column.get(key)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data -> ?")
    end

    it "generates -> operator with integer index" do
      column = Focus::JsonbColumn.new("data")
      index = Focus::IntLiteral(Int32).new(0)
      result = column.get(index)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data -> ?")
    end
  end

  describe "#get_text" do
    it "generates ->> operator with string key" do
      column = Focus::JsonbColumn.new("data")
      key = Focus::StringLiteral.new("key")
      result = column.get_text(key)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data ->> ?")
    end

    it "generates ->> operator with integer index" do
      column = Focus::JsonbColumn.new("data")
      index = Focus::IntLiteral(Int32).new(0)
      result = column.get_text(index)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data ->> ?")
    end
  end

  describe "#concat" do
    it "generates || operator" do
      column = Focus::JsonbColumn.new("data")
      json_value = JSON.parse(%({"extra": "field"}))
      literal = Focus::JsonbLiteral.new(json_value)
      result = column.concat(literal)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data || ?")
    end
  end

  describe "#delete" do
    it "generates - operator with string key" do
      column = Focus::JsonbColumn.new("data")
      key = Focus::StringLiteral.new("key")
      result = column.delete(key)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data - ?")
    end

    it "generates - operator with integer index" do
      column = Focus::JsonbColumn.new("data")
      index = Focus::IntLiteral(Int32).new(0)
      result = column.delete(index)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("data - ?")
    end
  end
end
