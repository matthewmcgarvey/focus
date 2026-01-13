class Focus::StringExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(value : String) : Focus::BoolExpression
    eq(Focus::StringLiteral.new(value))
  end

  def eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    binary_op("=", rhs)
  end

  def in_list(*vals : String) : Focus::BoolExpression
    in_list(vals.to_a)
  end

  def in_list(vals : Array(String)) : Focus::BoolExpression
    val_exprs = vals.map { |val| Focus::StringLiteral.new(val) }
    in_list(val_exprs)
  end

  def not_in_list(*vals : String) : Focus::BoolExpression
    not_in_list(vals.to_a)
  end

  def not_in_list(vals : Array(String)) : Focus::BoolExpression
    val_exprs = vals.map { |val| Focus::StringLiteral.new(val) }
    not_in_list(val_exprs)
  end
end
