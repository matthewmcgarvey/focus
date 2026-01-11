class Focus::StringExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(value : String) : Focus::BoolExpression
    eq(Focus::StringLiteral.new(value))
  end

  def in_list(*vals : String) : Focus::BoolExpression
    _in_list(*vals)
  end
end
