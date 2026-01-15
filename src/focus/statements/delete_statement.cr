abstract class Focus::DeleteStatement < Focus::Statement
  getter delete : Focus::DeleteClause
  getter where : Focus::WhereClause?
  getter returning : Focus::ReturningClause?

  def initialize(@delete : Focus::DeleteClause)
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
    Focus::SqlFormatter::StatementType::DELETE_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      delete,
      where,
      returning,
    ].compact
  end
end
