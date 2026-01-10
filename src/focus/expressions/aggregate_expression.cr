class Focus::AggregateExpression < Focus::Expression
  enum AggregateType
    MIN
    MAX
    AVG
    SUM
    COUNT
  end

  getter type : AggregateType
  getter argument : Focus::Expression

  def initialize(@type : AggregateType, @argument : Focus::Expression)
  end

  def to_projection : Focus::ProjectionExpression
    Focus::ProjectionExpression.new(self)
  end
end
