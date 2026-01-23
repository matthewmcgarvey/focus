class Focus::PG::SelectStatement < Focus::SelectStatement
  include Focus::PG::Statement
  include Focus::PG::Statements::Dsl::SetOperators

  property for_clause : Focus::ForClause?

  def distinct(*columns : Focus::Column) : self
    select_clause.distinct = true
    select_clause.distinct_on_columns = columns.to_a(&.as(Focus::Column))
    self
  end

  def for(
    strength : Focus::ForClause::LockStrength,
    wait_policy : Focus::ForClause::WaitPolicy? = nil,
    of tables : Array(Focus::Table)? = nil,
  ) : self
    @for_clause = Focus::ForClause.new(strength, wait_policy, tables.try(&.select(Focus::Table)))
    self
  end

  def ordered_clauses : Array(Focus::Clause)
    super + [for_clause].compact
  end
end
