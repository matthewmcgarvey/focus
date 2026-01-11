class Focus::TimeExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(value : Time) : Focus::BoolExpression
    eq(Focus::TimeLiteral.new(value))
  end
end
