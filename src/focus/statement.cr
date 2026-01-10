abstract class Focus::Statement < Focus::Expression
  include Focus::Queryable

  abstract def ordered_clauses : Array(Focus::Clause)

  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_statement(self)
  end
end
