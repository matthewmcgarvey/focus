class Focus::StringExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    _eq(rhs)
  end
end
