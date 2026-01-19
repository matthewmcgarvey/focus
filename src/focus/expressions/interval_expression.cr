class Focus::IntervalExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::IntervalExpression) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def between(min : Focus::IntervalExpression, max : Focus::IntervalExpression) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::IntervalExpression, max : Focus::IntervalExpression) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  def add(rhs : Focus::IntervalExpression) : Focus::IntervalExpression
    Focus::IntervalExpression.new(Focus::BinaryExpression.new(left: self, right: rhs, operator: "+"))
  end

  def sub(rhs : Focus::IntervalExpression) : Focus::IntervalExpression
    Focus::IntervalExpression.new(Focus::BinaryExpression.new(left: self, right: rhs, operator: "-"))
  end
end
