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
end
