abstract class Focus::DeleteStatement < Focus::Statement
  getter delete_clause : Focus::DeleteClause
  getter using_clause : Focus::UsingClause?
  getter where_clause : Focus::WhereClause?
  getter returning_clause : Focus::ReturningClause?

  def initialize(@delete_clause : Focus::DeleteClause)
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
    Focus::SqlFormatter::StatementType::DELETE_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      delete_clause,
      using_clause,
      where_clause,
      returning_clause,
    ].compact
  end
end
