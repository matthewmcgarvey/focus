module Focus::Dsl::Aggregation
  def count(column : Focus::Column? = nil) : AggregateExpression
    arg = column || Focus::WildcardExpression.new
    AggregateExpression.new(Focus::AggregateExpression::AggregateType::COUNT, arg)
  end
end
