module Stealth::Dsl::Operators(T)
  def eq(val : T) : Stealth::BinaryExpression(Bool)
    Stealth::BinaryExpression.new(
      Stealth::BinaryExpressionType::EQUAL,
      left: as_expression,
      right: wrap_argument(val),
      sql_type: Bool
    )
  end

  def between(range : Range(T, T)) : BetweenExpression(T)
    BetweenExpression.new(as_expression, wrap_argument(range.begin), wrap_argument(range.end))
  end

  def is_null : UnaryExpression(Bool)
    UnaryExpression.new(
      Stealth::UnaryExpressionType::IS_NULL,
      operand: as_expression,
      sql_type: Bool
    )
  end

  def is_not_null : UnaryExpression(Bool)
    UnaryExpression.new(
      Stealth::UnaryExpressionType::IS_NOT_NULL,
      operand: as_expression,
      sql_type: Bool
    )
  end

  def unary_minus : UnaryExpression(T)
    UnaryExpression.new(
      Stealth::UnaryExpressionType::UNARY_MINUS,
      operand: as_expression,
      sql_type: sql_type
    )
  end

  def unary_plus : UnaryExpression(T)
    UnaryExpression.new(
      Stealth::UnaryExpressionType::UNARY_PLUS,
      operand: as_expression,
      sql_type: sql_type
    )
  end

  def not : UnaryExpression(Bool)
    UnaryExpression.new(
      Stealth::UnaryExpressionType::NOT,
      operand: as_expression,
      sql_type: Bool
    )
  end
end
