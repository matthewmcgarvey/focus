class Focus::TimestampTzLiteral < Focus::TimestampTzExpression
  include Focus::Parameter

  getter value : Time

  def initialize(@value : Time)
  end
end
