module Focus::SqlExpression
  def accept(visitor : Focus::SqlVisitor) : Nil
    visitor.visit(self)
  end

  def wrap_in_parens? : Bool
    true
  end
end
