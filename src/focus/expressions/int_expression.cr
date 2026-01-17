class Focus::IntExpression(INT_TYPE) < Focus::NumericExpression
  def self.new_int_func(func_name : String, *expressions : Focus::Expression) : IntExpression(INT_TYPE)
    func = Focus::FunctionExpression.new(func_name, expressions.to_a.map(&.as(Focus::Expression)))
    Focus::IntExpression(INT_TYPE).new(func)
  end

  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def greater_than(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def less_than(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def between(min : Focus::IntExpression(INT_TYPE), max : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::IntExpression(INT_TYPE), max : Focus::IntExpression(INT_TYPE)) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  def add(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_add(rhs))
  end

  def sub(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_sub(rhs))
  end

  def mul(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_mul(rhs))
  end

  def div(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_div(rhs))
  end

  def mod(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_mod(rhs))
  end

  def mod(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_pow(rhs))
  end

  def bit_and(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(Focus::BinaryOperatorExpression.new(self, rhs, "&"))
  end

  def bit_or(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(Focus::BinaryOperatorExpression.new(self, rhs, "|"))
  end

  def bit_xor(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(Focus::BinaryOperatorExpression.new(self, rhs, "#"))
  end

  def bit_shift_left(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(Focus::BinaryOperatorExpression.new(self, rhs, "<<"))
  end

  def bit_shift_right(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    new_int_expr(Focus::BinaryOperatorExpression.new(self, rhs, ">>"))
  end

  def pow(rhs : Focus::NumericExpression) : Focus::IntExpression(INT_TYPE)
    new_int_expr(_pow(rhs))
  end

  def abs : Focus::IntExpression(INT_TYPE)
    new_int_expr(_abs)
  end

  private def new_int_expr(expr : Focus::Expression) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(expr)
  end
end
