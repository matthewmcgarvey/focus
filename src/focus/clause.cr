abstract class Focus::Clause
  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_clause(self)
  end
end
