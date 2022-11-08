module Stealth::SqlExpression
  def accept(visitor : Stealth::SqlVisitor) : Nil
    visitor.visit(self)
  end

  def wrap_in_parens? : Bool
    true
  end
end
