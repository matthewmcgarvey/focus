class Focus::HavingClause < Focus::Clause
  getter expression : Focus::BoolExpression

  def initialize(@expression)
  end
end
