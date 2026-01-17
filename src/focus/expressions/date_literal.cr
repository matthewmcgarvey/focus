class Focus::DateLiteral < Focus::DateExpression
  include Focus::Parameter

  getter value : Time

  def initialize(@value : Time)
  end
end
