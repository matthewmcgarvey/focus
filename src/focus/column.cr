module Focus::Column
  getter column_name : String
  property table_name : String?
  property subquery : Focus::SelectTable? = nil

  def asc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::ASCENDING)
  end

  def desc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::DESCENDING)
  end

  def from(table : Focus::SelectTable) : self
    col = self.class.new(self.column_name, self.table_name)
    col.subquery = table
    col
  end

  # Generic greater-than operator that accepts any SQL expression (including other columns).

  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_column(self)
  end
end
