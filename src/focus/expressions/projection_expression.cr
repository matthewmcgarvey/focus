class Focus::ProjectionExpression < Focus::Expression
  getter inner : Focus::Expression
  property projection_alias : String?

  def initialize(@inner : Focus::Expression, @projection_alias : String? = nil)
  end

  def to_projection : Focus::ProjectionExpression
    self
  end
end
