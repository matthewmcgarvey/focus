class Focus::IntExpression(INT_TYPE) < Focus::NumericExpression
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
    Focus::IntExpression(INT_TYPE).new(_add(rhs))
  end

  def sub(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(_sub(rhs))
  end

  def mul(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(_mul(rhs))
  end

  def div(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(_div(rhs))
  end

  def mod(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(_mod(rhs))
  end

  def mod(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    Focus::IntExpression(INT_TYPE).new(_pow(rhs))
  end

  def bit_and(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    expression = Focus::BinaryOperatorExpression.new(self, rhs, "&")
    Focus::IntExpression(INT_TYPE).new(expression)
  end

  def bit_or(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    expression = Focus::BinaryOperatorExpression.new(self, rhs, "|")
    Focus::IntExpression(INT_TYPE).new(expression)
  end

  def bit_xor(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    expression = Focus::BinaryOperatorExpression.new(self, rhs, "#")
    Focus::IntExpression(INT_TYPE).new(expression)
  end

  def bit_shift_left(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    expression = Focus::BinaryOperatorExpression.new(self, rhs, "<<")
    Focus::IntExpression(INT_TYPE).new(expression)
  end

  def bit_shift_right(rhs : Focus::IntExpression(INT_TYPE)) : Focus::IntExpression(INT_TYPE)
    expression = Focus::BinaryOperatorExpression.new(self, rhs, ">>")
    Focus::IntExpression(INT_TYPE).new(expression)
  end
end
