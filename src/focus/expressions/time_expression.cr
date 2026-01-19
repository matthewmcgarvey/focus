class Focus::TimeExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::TimeExpression) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def between(min : Focus::TimeExpression, max : Focus::TimeExpression) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::TimeExpression, max : Focus::TimeExpression) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  def sub(rhs : Focus::TimeExpression) : Focus::IntervalExpression
    Focus::IntervalExpression.new(Focus::BinaryExpression.new(left: self, right: rhs, operator: "-"))
  end
end
