class Focus::TimeLiteral < Focus::TimeExpression
  include Focus::Parameter

  getter value : Time

  def initialize(@value : Time)
  end
end
