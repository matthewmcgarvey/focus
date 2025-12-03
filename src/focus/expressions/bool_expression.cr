class Focus::BoolExpression < Focus::Expression
  getter inner : Focus::Expression

  def initialize(@inner : Focus::Expression)
  end
end
