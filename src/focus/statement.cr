abstract class Focus::Statement < Focus::Expression
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_statement(self)
  end

  def to_sql
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_with_args
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
