class Focus::LiteralExpression(T) < Focus::Expression
  include Focus::Parameter

  getter value : T
  getter constant : Bool

  def initialize(@value : T, @constant : Bool = false)
  end
end
