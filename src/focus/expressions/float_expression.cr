class Focus::FloatExpression(FLOAT_TYPE) < Focus::NumericExpression
  def self.new_float_func(func_name : String, *expressions : Focus::Expression) : FloatExpression(FLOAT_TYPE)
    func = Focus::FunctionExpression.new(func_name, expressions.to_a.map(&.as(Focus::Expression)))
    Focus::FloatExpression(FLOAT_TYPE).new(func)
  end

  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def greater_than(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def less_than(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def between(min : Focus::FloatExpression(FLOAT_TYPE), max : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _betwen(min, max, negated: false)
  end

  def not_between(min : Focus::FloatExpression(FLOAT_TYPE), max : Focus::FloatExpression(FLOAT_TYPE)) : Focus::BoolExpression
    _betwen(min, max, negated: true)
  end

  def add(rhs : Focus::NumericExpression) : Focus::FloatExpression(FLOAT_TYPE)
    new_float_expr(_add(rhs))
  end

  def sub(rhs : Focus::NumericExpression) : Focus::FloatExpression(FLOAT_TYPE)
    new_float_expr(_sub(rhs))
  end

  def mul(rhs : Focus::NumericExpression) : Focus::FloatExpression(FLOAT_TYPE)
    new_float_expr(_mul(rhs))
  end

  def div(rhs : Focus::NumericExpression) : Focus::FloatExpression(FLOAT_TYPE)
    new_float_expr(_div(rhs))
  end

  def mod(rhs : Focus::NumericExpression) : Focus::FloatExpression(FLOAT_TYPE)
    new_float_expr(_mod(rhs))
  end

  private def new_float_expr(expr : Focus::Expression) : Focus::FloatExpression(FLOAT_TYPE)
    Focus::FloatExpression(FLOAT_TYPE).new(expr)
  end
end
