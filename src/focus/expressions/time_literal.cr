class Focus::TimeLiteral < Focus::TimeExpression
  include Focus::Parameter

  getter value : String

  def initialize(@value : String)
  end
end
