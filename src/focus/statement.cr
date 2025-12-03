abstract class Focus::Statement < Focus::Expression
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_statement(self)
  end

  def to_sql
    visitor = Focus::SqlFormatter.new
    accept(visitor)
    visitor.to_sql
  end
end
