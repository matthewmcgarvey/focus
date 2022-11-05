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

  protected def wrap_argument(argument : V) : ArgumentExpression(V) forall V
    ArgumentExpression.new(argument, sql_type)
  end
end
