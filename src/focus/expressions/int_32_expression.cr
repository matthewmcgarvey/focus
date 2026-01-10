class Focus::IntExpression(INT_TYPE) < Focus::Expression
  include Focus::Parameter

  getter value : INT_TYPE

  def initialize(@value : INT_TYPE)
  end
end
