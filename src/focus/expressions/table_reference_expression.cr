class Focus::TableReferenceExpression < Focus::Expression
  include Focus::TableSource

  getter table_name : String
  getter table_alias : String?

  def initialize(@table_name : String, @table_alias : String? = nil)
  end
end
