abstract class Focus::InsertStatement < Focus::Statement
  getter insert_clause : Focus::InsertClause
  getter values_clause : Focus::ValuesClause?
  getter query : Focus::QueryClause?
  getter returning : Focus::ReturningClause?

  def initialize(@insert_clause : Focus::InsertClause)
  end

  def values(*raw_values) : self
    @values_clause ||= Focus::ValuesClause.new
    clause = self.values_clause
    raise "unreachable" if clause.nil?

    row = raw_values.map { |raw| Focus::GenericValueExpression.new(raw) }.select(Focus::ValueExpression)
    clause.add_row(row)
    self
  end

  def query(query : Focus::SelectStatement) : self
    @query = Focus::QueryClause.new(query)
    self
  end

  def returning(*returning_vals : Focus::Expression) : self
    @returning = Focus::ReturningClause.new(returning_vals.select(Focus::Expression))
    self
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::INSERT_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      insert_clause,
      values_clause,
      query,
      returning,
    ].compact
  end
end
