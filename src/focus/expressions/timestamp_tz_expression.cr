class Focus::TimestampTzExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::TimestampTzExpression) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def between(min : Focus::TimestampTzExpression, max : Focus::TimestampTzExpression) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::TimestampTzExpression, max : Focus::TimestampTzExpression) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  def add(interval : Focus::IntervalExpression) : Focus::TimestampTzExpression
    Focus::TimestampTzExpression.new(Focus::BinaryExpression.new(left: self, right: interval, operator: "+"))
  end

  def sub(interval : Focus::IntervalExpression) : Focus::TimestampTzExpression
    Focus::TimestampTzExpression.new(Focus::BinaryExpression.new(left: self, right: interval, operator: "-"))
  end

  def sub(rhs : Focus::TimestampTzExpression) : Focus::IntervalExpression
    Focus::IntervalExpression.new(Focus::BinaryExpression.new(left: self, right: rhs, operator: "-"))
  end
end
