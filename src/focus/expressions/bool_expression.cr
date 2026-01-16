class Focus::BoolExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def and(right : Focus::BoolExpression) : Focus::BoolExpression
    binary_expr = Focus::BinaryExpression.new(self, right, "AND")
    Focus::BoolExpression.new(binary_expr)
  end

  def or(right : Focus::BoolExpression) : Focus::BoolExpression
    binary_expr = Focus::BinaryExpression.new(self, right, "OR")
    Focus::BoolExpression.new(binary_expr)
  end

  def eq(rhs : Focus::BoolExpression) : Focus::BoolExpression
    _eq(rhs)
  end
end
