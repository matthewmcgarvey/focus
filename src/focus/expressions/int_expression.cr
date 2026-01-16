class Focus::IntExpression(INT_TYPE) < Focus::NumericExpression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _eq(rhs)
  end

  def greater_than(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _greater_than(rhs)
  end
end
