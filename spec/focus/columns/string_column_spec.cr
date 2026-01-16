require "../../spec_helper"

describe Focus::StringColumn do
  describe "#in_list" do
    it "works" do
      column = Focus::StringColumn.new("foo")

      result = column.in_list(Focus.string("a"), Focus.string("b"))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo IN (?, ?)")
    end
  end

  describe "#between" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      result = column.between(Focus.string("a"), Focus.string("z"))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo BETWEEN ? AND ?")
    end
  end

  describe "#like" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      result = column.like(Focus.string("%abc%"))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo LIKE ?")
    end
  end

  describe "#concat" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      result = column.concat(Focus.string("abc"))

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo || ?")
    end
  end
end
