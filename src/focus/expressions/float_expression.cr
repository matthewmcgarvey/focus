class Focus::FloatExpression(FLOAT_TYPE) < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _eq(rhs)
  end

  def greater_than(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _greater_than(rhs)
  end
end
