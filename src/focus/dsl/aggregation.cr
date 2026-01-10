module Focus::Dsl::Aggregation
  def count(column : Focus::Column? = nil) : AggregateExpression
    arg = column || Focus::WildcardExpression.new
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::COUNT, arg)
  end

  def sum(column : Focus::Column) : AggregateExpression
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::SUM, column)
  end

  def avg(column : Focus::Column) : AggregateExpression
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::AVG, column)
  end

  def min(column : Focus::Column) : AggregateExpression
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::MIN, column)
  end

  def max(column : Focus::Column) : AggregateExpression
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::MAX, column)
  end
end
