class Focus::BetweenOperatorExpression < Focus::BoolExpression
  getter expression : Focus::Expression
  getter negated : Bool
  getter min : Focus::Expression
  getter max : Focus::Expression

  def initialize(@expression, @negated, @min, @max)
  end
end
