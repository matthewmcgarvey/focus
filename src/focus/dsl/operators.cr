module Focus::Dsl::TopLevelOperators
  def exists(query : Focus::SelectQuery) : ExistsExpression
    ExistsExpression.new(query.expression)
  end

  def not_exists(query : Focus::SelectQuery) : ExistsExpression
    ExistsExpression.new(query.expression, not_exists: true)
  end
end
