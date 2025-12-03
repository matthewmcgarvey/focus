class Focus::WhereClause < Focus::Clause
  getter expression : Focus::BoolExpression

  def initialize(@expression)
  end
end
