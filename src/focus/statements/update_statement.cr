abstract class Focus::UpdateStatement < Focus::Statement
  getter update : Focus::UpdateClause
  getter set : Focus::SetClause?
  getter where : Focus::WhereClause?
  getter returning : Focus::ReturningClause?

  def initialize(@update : Focus::UpdateClause)
  end

  def set(column : Focus::Column, expr : Focus::Expression) : self
    @set ||= Focus::SetClause.new
    set_clause = self.set
    raise "unreachable" if set_clause.nil?

    col_token = Focus::ColumnToken.new(column.column_name)
    set_clause.add_column(col_token, expr)
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

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::UPDATE_STMT_TYPE
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
