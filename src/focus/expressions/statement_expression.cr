class Focus::StatementExpression < Focus::Expression
  getter statement : Focus::SelectStatement

  def initialize(@statement : Focus::SelectStatement)
  end
end
