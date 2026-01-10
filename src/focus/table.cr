abstract class Focus::Table
  include Focus::UpdateableTable
  include Focus::Joinable

  getter table_name : String
  getter table_alias : String?
  getter columns : Array(Focus::Column)

  abstract def dialect : Focus::Dialect

  def initialize(@table_name : String, @table_alias : String?, @columns : Array(Focus::Column))
    @columns.each(&.table_name=(@table_alias || @table_name))
  end

  def as_table_source : Focus::TableSource
    Focus::TableReferenceExpression.new(table_name)
  end

  def aliased(table_alias : String? = nil) : Focus::Table
    self.class.new(table_name, table_alias)
  end
end
