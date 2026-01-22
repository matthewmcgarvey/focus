class Focus::ComplexExpression < Focus::Expression
  getter inner : Focus::Expression

  def initialize(@inner : Focus::Expression)
  end
end
