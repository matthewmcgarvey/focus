abstract class Focus::Expression
  def accept(visitor : SqlVisitor) : Nil
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

  def is_null : Focus::BoolExpression
    postfix = Focus::PostfixOperatorExpression.new(self, "IS NULL")
    Focus::BoolExpression.new(postfix)
  end

  def is_not_null : Focus::BoolExpression
    postfix = Focus::PostfixOperatorExpression.new(self, "IS NOT NULL")
    Focus::BoolExpression.new(postfix)
  end

  def to_sql
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_with_args : Tuple(String, Array(DB::Any))
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  # Helper to build simple binary boolean expressions for this column.
  private def binary_op(operator : String, rhs : Focus::Expression) : Focus::BoolExpression
    expression = Focus::BinaryExpression.new(left: self, right: rhs, operator: operator)
    Focus::BoolExpression.new(expression)
  end
end
