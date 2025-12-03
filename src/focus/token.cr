abstract class Focus::Token
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit_token(self)
  end
end
