class Focus::IntExpression(INT_TYPE) < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    binary_op("=", rhs)
  end

  def greater_than(value : INT_TYPE) : Focus::BoolExpression
    greater_than(Focus::IntLiteral(INT_TYPE).new(value))
  end
end
