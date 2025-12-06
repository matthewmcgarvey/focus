abstract class Focus::Expression
  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_expression(self)
  end

  def aliased(alias_str : String) : Focus::ProjectionExpression
    Focus::ProjectionExpression.new(self, alias_str)
  end

  def in_list(*expressions : Focus::Expression) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(
      left: self,
      right: Focus::FunctionExpression.new(name: "", parameters: expressions.select(Focus::Expression)),
      operator: "IN"
    )
    Focus::BoolExpression.new(binary)
  end

  def not_in_list(*expressions : Focus::Expression) : Focus::BoolExpression
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

  def to_sql_with_args : Tuple(String, Array(Focus::Parameter))
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  private def _in_list(*vals : T) : Focus::BoolExpression forall T
    val_exprs = vals.map { |val| Focus::GenericValueExpression.new(val) }.select(Focus::Expression)
    rhs = Focus::FunctionExpression.new(name: "", parameters: val_exprs)
    binary = Focus::BinaryExpression.new(
      left: self,
      right: rhs,
      operator: "IN"
    )
    Focus::BoolExpression.new(binary)
  end
end
