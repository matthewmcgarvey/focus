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
end
