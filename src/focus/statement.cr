abstract class Focus::Statement < Focus::Expression
  include Focus::Queryable

  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_statement(self)
  end
end
