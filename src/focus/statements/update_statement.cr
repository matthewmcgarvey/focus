abstract class Focus::UpdateStatement < Focus::Statement
  getter update_clause : Focus::UpdateClause
  getter set_clause : Focus::SetClause?
  getter from_clause : Focus::FromClause?
  getter where_clause : Focus::WhereClause?
  getter returning_clause : Focus::ReturningClause?

  def initialize(@update_clause : Focus::UpdateClause)
  end

  def set(column : Focus::Column, expr : Focus::Expression | Focus::SelectStatement) : self
    @set_clause ||= Focus::SetClause.new
    clause = self.set_clause
    raise "unreachable" if clause.nil?

    col_token = Focus::ColumnToken.new(column.column_name)
    clause.add_column(col_token, expr)
    self
  end

  def set(column : Focus::Column, val : T) : self forall T
    expr = Focus::GenericValueExpression.new(val)
    set(column, expr)
  end

  def from(table : Focus::ReadableTable) : self
    @from_clause = Focus::FromClause.new(table)
    self
  end

  def where(expression : Focus::BoolExpression) : self
    @where_clause = Focus::WhereClause.new(expression)
    self
  end

  def returning(*returning_vals : Focus::Expression) : self
    @returning_clause = Focus::ReturningClause.new(returning_vals.select(Focus::Expression))
    self
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::UPDATE_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      update_clause,
      set_clause,
      from_clause,
      where_clause,
      returning_clause,
    ].compact
  end
end
