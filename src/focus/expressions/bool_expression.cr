class Focus::BoolExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def and(rhs : Focus::BoolExpression) : Focus::BoolExpression
    binary_op("AND", rhs)
  end

  def or(rhs : Focus::BoolExpression) : Focus::BoolExpression
    binary_op("OR", rhs)
  end

  def eq(rhs : Focus::BoolExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::BoolExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::BoolExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::BoolExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def is_true : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS TRUE")
    Focus::BoolExpression.new(expression)
  end

  def is_not_true : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS NOT TRUE")
    Focus::BoolExpression.new(expression)
  end

  def is_false : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS FALSE")
    Focus::BoolExpression.new(expression)
  end

  def is_not_false : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS NOT FALSE")
    Focus::BoolExpression.new(expression)
  end

  def is_unknown : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS UNKNOWN")
    Focus::BoolExpression.new(expression)
  end

  def is_not_unknown : Focus::BoolExpression
    expression = Focus::PostfixOperatorExpression.new(self, "IS NOT UNKNOWN")
    Focus::BoolExpression.new(expression)
  end
end
