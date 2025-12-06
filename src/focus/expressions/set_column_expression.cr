class Focus::SetColumnExpression < Focus::Expression
  getter column : Focus::ColumnToken
  getter value : Focus::Expression

  def initialize(@column : Focus::ColumnToken, @value : Focus::Expression)
  end
end
