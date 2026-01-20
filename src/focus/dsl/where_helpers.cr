module Focus::Dsl::WhereHelpers
  def and(*expressions : Focus::BoolExpression) : BoolExpression
    expressions.reduce { |acc, expr| acc.and(expr) }
  end

  def or(*conditions : Focus::BoolExpression) : BoolExpression
    expressions.reduce { |acc, expr| acc.or(expr) }
  end
end
