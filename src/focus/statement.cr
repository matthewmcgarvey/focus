abstract class Focus::Statement < Focus::Expression
  include Focus::Queryable

  abstract def ordered_clauses : Array(Focus::Clause)
  abstract def statement_type : Focus::SqlFormatter::StatementType
  abstract def dialect : Focus::Dialect

  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_statement(self)
  end

  def to_sql
    visitor = dialect.formatter
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_with_args : Tuple(String, Array(DB::Any))
    visitor = dialect.formatter
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  # Token-based SQL generation (for comparison with to_sql)
  def to_sql_via_tokens
    visitor = dialect.token_formatter
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_via_tokens_with_args : Tuple(String, Array(DB::Any))
    visitor = dialect.token_formatter
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  # Returns the raw token list for debugging/testing
  def to_tokens : Array(Sql::Token)
    visitor = dialect.token_formatter
    accept(visitor)
    visitor.tokens
  end
end
