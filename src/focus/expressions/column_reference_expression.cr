class Focus::ColumnReferenceExpression < Focus::Expression
  property table_name : String?
  property column_name : String

  def initialize(@column_name : String, @table_name : String? = nil)
  end
end
