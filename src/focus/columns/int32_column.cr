class Focus::Int32Column < Focus::Column
  def greater_than(right : Int32) : Focus::BoolExpression
    greater_than(Focus::Int32Expression.new(right))
  end

  def greater_than(right : Focus::Int32Expression) : Focus::BoolExpression
    expression = Focus::BinaryExpression.new(
      left: self,
      right: right,
      operator: ">"
    )
    Focus::BoolExpression.new(expression)
  end

  def eq(rhs : Focus::Int32Column) : Focus::BoolExpression
    binary = Focus::BinaryExpression.new(self, rhs, "=")
    Focus::BoolExpression.new(binary)
  end
end
