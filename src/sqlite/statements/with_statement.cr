class Focus::SQLite::WithStatement < Focus::SQLite::Statement
  getter ctes : Array(Focus::CommonTableExpression)
  getter primary_statement : Focus::SQLite::Statement?

  def initialize(@ctes : Array(Focus::CommonTableExpression))
  end

  def statement(stmt : Focus::SQLite::Statement) : self
    @primary_statement = stmt
    self
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::WITH_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    raise "this shouldn't be called"
  end
end
