abstract class Focus::Clause
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_clause(self)
  end
end
