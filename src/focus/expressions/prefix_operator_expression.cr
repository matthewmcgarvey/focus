class Focus::PrefixOperatorExpression < Focus::Expression
  getter expression : Focus::Expression
  getter operator : String

  def initialize(@operator : String, @expression : Focus::Expression)
  end
end
