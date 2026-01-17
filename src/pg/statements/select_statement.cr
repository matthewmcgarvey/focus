class Focus::PG::SelectStatement < Focus::SelectStatement
  include Focus::PG::Statement

  property for_clause : Focus::ForClause?

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
