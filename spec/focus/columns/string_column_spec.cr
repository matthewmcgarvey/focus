require "../../spec_helper"

describe Focus::StringColumn do
  describe "#in_list" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      str_a = Focus::StringLiteral.new("a")
      str_b = Focus::StringLiteral.new("b")

      result = column.in_list(str_a, str_b)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo IN (?, ?)")
    end
  end

  describe "#between" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      str_a = Focus::StringLiteral.new("a")
      str_z = Focus::StringLiteral.new("z")
      result = column.between(str_a, str_z)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo BETWEEN ? AND ?")
    end
  end

  describe "#like" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      str_like = Focus::StringLiteral.new("%abc%")
      result = column.like(str_like)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo LIKE ?")
    end
  end

  describe "#concat" do
    it "works" do
      column = Focus::StringColumn.new("foo")
      str_abc = Focus::StringLiteral.new("abc")
      result = column.concat(str_abc)

      visitor = Focus::SqlFormatter.new
      result.accept(visitor)
      visitor.to_sql.should eq("foo || ?")
    end
  end
end
