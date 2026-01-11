class Focus::SelectTable
  include Focus::ReadableTable
  include Focus::SerializableTable

  getter statement : Focus::Statement # TODO: statement with expressions type of module that SelectStatement includes
  getter alias : String?
  getter column_aliases : Array(Focus::ColumnReferenceExpression)?

  def initialize(@statement, @alias, @column_aliases = nil)
  end
end
