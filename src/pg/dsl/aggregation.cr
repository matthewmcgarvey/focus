module Focus::PG::Dsl::Aggregation
  def array_agg(expr : T) : Focus::ArrayExpression(T) forall T
    {% raise "#{T} must inherit from Focus::Expression" unless T <= Focus::Expression %}
    Focus::ArrayExpression(T).new(AggregateExpression.new("ARRAY_AGG", expr))
  end
end
