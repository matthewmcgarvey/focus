class Focus::PostfixOperatorExpression < Focus::Expression
  getter expression : Focus::Expression
  getter operator : String

  def initialize(@expression : Focus::Expression, @operator : String)
  end
end
