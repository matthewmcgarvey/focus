abstract class Focus::Expression
  # The visitor pattern seems to fail with generic types
  # the {% @type %} here is to force the compiler to instantiate a separate def for each generic instance
  # https://forum.crystal-lang.org/t/incorrect-overload-selected-with-freevar-and-generic-inheritance/3625
  def accept(visitor : SqlVisitor) : Nil
    {% @type %}
    visitor.visit_expression(self)
  end

  def aliased(alias_str : String) : Focus::AliasedExpression
    Focus::AliasedExpression.new(self, alias_str)
  end

  def in_list(*expressions : Focus::Expression) : Focus::BoolExpression
    in_list(expressions.to_a)
  end

  def in_list(expressions : Array(Focus::Expression)) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(
      left: self,
      right: Focus::FunctionExpression.new(name: "", parameters: expressions.select(Focus::Expression)),
      operator: "IN"
    )
    Focus::BoolExpression.new(binary)
  end

  def in_list(statement : Focus::SelectStatement) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(
      left: self,
      right: Focus::StatementExpression.new(statement),
      operator: "IN"
    )
    Focus::BoolExpression.new(binary)
  end

  def not_in_list(*expressions : Focus::Expression) : Focus::BoolExpression
    not_in_list(expressions.to_a)
  end

  def not_in_list(expressions : Array(Focus::Expression)) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(
      left: self,
      right: Focus::FunctionExpression.new(name: "", parameters: expressions.select(Focus::Expression)),
      operator: "NOT IN"
    )
    Focus::BoolExpression.new(binary)
  end

  def not_in_list(statement : Focus::SelectStatement) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(
      left: self,
      right: Focus::StatementExpression.new(statement),
      operator: "NOT IN"
    )
    Focus::BoolExpression.new(binary)
  end

  def is_null : Focus::BoolExpression
    postfix = Focus::PostfixOperatorExpression.new(self, "IS NULL")
    Focus::BoolExpression.new(postfix)
  end

  def is_not_null : Focus::BoolExpression
    postfix = Focus::PostfixOperatorExpression.new(self, "IS NOT NULL")
    Focus::BoolExpression.new(postfix)
  end

  private def _eq(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("=", rhs)
  end

  private def _not_eq(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("!=", rhs)
  end

  private def _is_distinct_from(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("IS DISTINCT FROM", rhs)
  end

  private def _is_not_distinct_from(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("IS NOT DISTINCT FROM", rhs)
  end

  private def _greater_than(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op(">", rhs)
  end

  private def _greater_than_eq(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op(">=", rhs)
  end

  private def _less_than(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("<", rhs)
  end

  private def _less_than_eq(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("<=", rhs)
  end

  private def _between(min : Focus::Expression, max : Focus::Expression, negated : Bool) : Focus::BoolExpression
    Focus::BetweenOperatorExpression.new(
      self,
      negated: negated,
      min: min,
      max: max
    )
  end

  # Helper to build binary boolean expressions for this column.
  private def binary_op(operator : String, rhs : Focus::Expression) : Focus::BoolExpression
    expression = Focus::BinaryExpression.new(left: self, right: rhs, operator: operator)
    Focus::BoolExpression.new(Focus::ComplexExpression.new(expression))
  end
end
