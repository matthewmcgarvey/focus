class Focus::BoolExpression < Focus::Expression
  getter inner : Focus::Expression

  def initialize(@inner : Focus::Expression)
  end

  def and(right : Focus::BoolExpression) : Focus::BoolExpression
    binary_expr = Focus::BinaryExpression.new(self, right, "AND")
    Focus::BoolExpression.new(binary_expr)
  end
end
