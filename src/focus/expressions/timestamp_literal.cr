class Focus::TimestampLiteral < Focus::TimestampExpression
  include Focus::Parameter

  getter value : Time

  def initialize(@value : Time)
  end
end
