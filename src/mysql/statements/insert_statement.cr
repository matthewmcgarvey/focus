class Focus::MySql::InsertStatement < Focus::Statement
  getter insert_clause : Focus::InsertClause
  getter values_clause : Focus::ValuesClause?
  getter query : Focus::MySql::SelectStatement?
  getter returning : Focus::ReturningClause?

  def initialize(@insert_clause : Focus::InsertClause)
  end

  def values(*raw_values) : self
    row = raw_values.map { |raw| Focus::GenericValueExpression.new(raw) }.select(Focus::ValueExpression)
    row_constructor = Focus::RowConstructorExpression.new(row)
    if clause = self.values_clause
      clause.rows << row_constructor
    else
      clause = Focus::ValuesClause.new([row_constructor])
      @values_clause = clause
    end
    self
  end

  def query(query : Focus::SelectStatement) : self
    @query = query
    self
  end

  def returning(*returning_vals : Focus::Expression) : self
    @returning = Focus::ReturningClause.new(returning_vals.select(Focus::Expression))
    self
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      insert_clause,
      values_clause,
      query,
      returning
    ].compact
  end
end
