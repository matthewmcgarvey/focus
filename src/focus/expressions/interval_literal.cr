class Focus::IntervalLiteral < Focus::IntervalExpression
  include Focus::Parameter

  getter value : String

  def initialize(@value : String)
  end
end
