abstract class Focus::Token < Focus::Expression
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_token(self)
  end
end
