class Focus::FloatLiteral(FLOAT_TYPE) < Focus::FloatExpression(FLOAT_TYPE)
  include Focus::Parameter

  getter value : FLOAT_TYPE

  def initialize(@value : FLOAT_TYPE)
  end
end
