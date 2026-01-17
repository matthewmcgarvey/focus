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

  def initialize(type : String, @argument : Focus::Expression)
    @type = AggregateType.parse(type)
  end
end
