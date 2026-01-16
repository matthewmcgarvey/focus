class Focus::StringExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::StringExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::StringExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::StringExpression) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::StringExpression) : Focus::BoolExpression
    _greatter_than(rhs)
  end

  def greater_than_eq(rhs : Focus::StringExpression) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def between(min : Focus::StringExpression, max : Focus::StringExpression) : Focus::BoolExpression
    _between(min, max, negated: false)
  end

  def not_between(min : Focus::StringExpression, max : Focus::StringExpression) : Focus::BoolExpression
    _between(min, max, negated: true)
  end

  # arg type is Focus::Expression because the database will automatically cast the types to string
  # which allows `SELECT 'Price: $' || 100 AS product_price;`
  def concat(rhs : Focus::Expression) : Focus::StringExpression
    expression = Focus::BinaryExpression.new(left: self, right: rhs, operator: "||")
    Focus::StringExpression.new(expression)
  end

  def like(pattern : Focus::StringExpression) : Focus::BoolExpression
    binary_op("LIKE", pattern)
  end

  def not_like(pattern : Focus::StringExpression) : Focus::BoolExpression
    binary_op("NOT LIKE", pattern)
  end
end
