abstract class Stealth::SqlExpression
  def accept(visitor : Stealth::SqlExpressionVisitor) : Nil
    visitor.visit(self)
  end
end
