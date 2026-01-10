class Focus::PG::UpdateStatement < Focus::PG::Statement
  getter update : Focus::UpdateClause
  getter set : Focus::SetClause?
  getter where : Focus::WhereClause?
  getter returning : Focus::ReturningClause?

  def initialize(@update : Focus::UpdateClause)
  end

  def set(column : Focus::Column, expr : Focus::Expression) : self
    col_token = Focus::ColumnToken.new(column.column_name)
    set_column = Focus::SetColumnExpression.new(col_token, expr)
    if set_clause = self.set
      set_clause.set_columns << set_column
    else
      @set = Focus::SetClause.new([set_column])
    end
    self
  end

  def set(column : Focus::Column, val : T) : self forall T
    expr = Focus::GenericValueExpression.new(val)
    set(column, expr)
  end

  def where(expression : Focus::BoolExpression) : self
    @where = Focus::WhereClause.new(expression)
    self
  end

  def returning(*returning_vals : Focus::Expression) : self
    @returning = Focus::ReturningClause.new(returning_vals.select(Focus::Expression))
    self
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      update,
      set,
      where,
      returning,
    ].compact
  end
end
