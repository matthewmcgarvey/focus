class Focus::AliasedExpression < Focus::Expression
  getter inner : Focus::Expression
  property alias : String?

  def initialize(@inner : Focus::Expression, @alias : String? = nil)
  end
end
