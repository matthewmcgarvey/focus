class Focus::InsertClause < Focus::Clause
  getter table : Focus::TableReferenceExpression
  getter columns : Array(Focus::ColumnToken)

  def initialize(@table : Focus::TableReferenceExpression, @columns : Array(Focus::ColumnToken))
  end
end
