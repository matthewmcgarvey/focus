class Focus::ValuesClause < Focus::Clause
  property rows : Array(Focus::RowConstructorExpression)

  def initialize(@rows : Array(Focus::RowConstructorExpression))
  end
end
