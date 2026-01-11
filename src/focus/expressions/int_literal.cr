class Focus::IntLiteral(INT_TYPE) < Focus::IntExpression(INT_TYPE)
  include Focus::Parameter

  getter value : INT_TYPE

  def initialize(@value : INT_TYPE)
  end
end
