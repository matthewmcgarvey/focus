class Focus::AliasedExpression < Focus::Expression
  getter inner : Focus::Expression
  getter alias : String

  def initialize(@inner : Focus::Expression, @alias : String)
  end
end
