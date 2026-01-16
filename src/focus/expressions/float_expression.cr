class Focus::FloatExpression(FLOAT_TYPE) < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    binary_op("=", rhs)
  end

  def greater_than(value : FLOAT_TYPE) : Focus::BoolExpression
    greater_than(Focus::FloatLiteral(FLOAT_TYPE).new(value))
  end
end
