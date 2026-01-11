module Focus::Parameter
  abstract def value

  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_literal(self)
  end
end
