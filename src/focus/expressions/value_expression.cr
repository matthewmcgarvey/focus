abstract class Focus::ValueExpression < Focus::Expression
  include Focus::Parameter

  abstract def value
end

class Focus::GenericValueExpression(T) < Focus::ValueExpression
  getter value : T

  def initialize(@value : T)
  end
end
