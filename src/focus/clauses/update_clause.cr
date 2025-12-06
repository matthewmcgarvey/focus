class Focus::UpdateClause < Focus::Clause
  getter table : Focus::TableReferenceExpression

  def initialize(@table : Focus::TableReferenceExpression)
  end
end
