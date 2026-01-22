class Focus::ArrayLiteral(T) < Focus::ArrayExpression(T)
  include Focus::Parameter

  getter value : Array(T)

  def initialize(@value : Array(T))
  end
end
