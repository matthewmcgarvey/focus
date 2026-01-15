require "../spec_helper"

describe Focus::Column do
  context "converted to sql" do
    it "does not quote table with all lower case and underscores" do
      column = Focus::StringColumn.new("foo", table_name: "my_table")
      visitor = Focus::SqlFormatter.new

      column.accept(visitor)
      visitor.to_sql.should eq("my_table.foo")
    end

    it "quotes mixed case column names" do
      column = Focus::StringColumn.new("mixedCase")
      visitor = Focus::SqlFormatter.new

      column.accept(visitor)
      visitor.to_sql.should eq("\"mixedCase\"")
    end
  end
end
