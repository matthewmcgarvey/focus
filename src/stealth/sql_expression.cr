abstract class Stealth::SqlExpression
  def accept(visitor : Stealth::SqlVisitor) : Nil
    visitor.visit(self)
  end
end
