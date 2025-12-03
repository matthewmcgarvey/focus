class Focus::BinaryExpression < Focus::Expression
  getter left : Focus::Expression
  getter right : Focus::Expression
  getter operator : String

  def initialize(@left : Focus::Expression, @right : Focus::Expression, @operator : String)
  end
end
