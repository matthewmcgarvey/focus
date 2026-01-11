module Focus::SerializableTable
  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_table(self)
  end
end
