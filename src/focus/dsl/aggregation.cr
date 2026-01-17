module Focus::Dsl::Aggregation
  def count(expr : Focus::Expression? = nil) : AggregateExpression
    arg = expr || Focus::WildcardExpression.new
    AggregateExpression.new("COUNT", arg)
  end

  def sum(expr : Focus::Expression) : AggregateExpression
    AggregateExpression.new("SUM", expr)
  end

  def avg(expr : Focus::Expression) : AggregateExpression
    AggregateExpression.new("AVG", expr)
  end

  def min(expr : Focus::Expression) : AggregateExpression
    AggregateExpression.new("MIN", expr)
  end

  def max(expr : Focus::Expression) : AggregateExpression
    AggregateExpression.new("MAX", expr)
  end
end
