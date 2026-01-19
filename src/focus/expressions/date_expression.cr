class Focus::DateExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::DateExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::DateExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::DateExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::DateExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::DateExpression) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::DateExpression) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::DateExpression) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::DateExpression) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def between(min : Focus::DateExpression, max : Focus::DateExpression) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::DateExpression, max : Focus::DateExpression) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  def add(interval : Focus::IntervalExpression) : Focus::TimestampExpression
    Focus::TimestampExpression.new(Focus::BinaryExpression.new(left: self, right: interval, operator: "+"))
  end

  def sub(interval : Focus::IntervalExpression) : Focus::TimestampExpression
    Focus::TimestampExpression.new(Focus::BinaryExpression.new(left: self, right: interval, operator: "-"))
  end
end
