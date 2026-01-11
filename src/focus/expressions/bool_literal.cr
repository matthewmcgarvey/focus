class Focus::BoolLiteral < Focus::BoolExpression
  include Focus::Parameter

  getter value : Bool

  def initialize(@value : Bool)
  end
end
