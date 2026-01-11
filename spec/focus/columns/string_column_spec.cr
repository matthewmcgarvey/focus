require "../../spec_helper"

describe Focus::StringColumn do
  describe "#in_list" do
    it "works" do
      column = Focus::StringColumn.new("foo")

      result = column.in_list("a", "b")

      formatter = Focus::SqlFormatter.new
      result.accept(formatter)
      formatter.to_sql.should eq("foo IN (?, ?)")
    end
  end
end
