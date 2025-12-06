class Focus::SetClause < Focus::Clause
  getter set_columns : Array(Focus::SetColumnExpression)

  def initialize(@set_columns : Array(Focus::SetColumnExpression))
  end
end
