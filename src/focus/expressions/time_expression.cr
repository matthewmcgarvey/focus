class Focus::TimeExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::TimeExpression) : Focus::BoolExpression
    binary_op("=", rhs)
  end
end
