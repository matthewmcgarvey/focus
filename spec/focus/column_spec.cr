require "../spec_helper"

class SpecColumn < Focus::Column
  def initialize(@column_name : String, @table_name : String? = nil)
  end
end

describe Focus::Column do
  context "converted to sql" do
    it "does not quote table with all lower case and underscores" do
      column = SpecColumn.new("foo", table_name: "my_table")

      column.to_sql.should eq("my_table.foo")
    end

    it "quotes mixed case column names" do
      column = SpecColumn.new("mixedCase")

      column.to_sql.should eq("\"mixedCase\"")
    end
  end
end
