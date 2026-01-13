module Focus::Column
  property table_name : String?
  getter column_name : String

  def asc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::ASCENDING)
  end

  def desc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::DESCENDING)
  end

  def from(table : Focus::ReadableTable) : self
    table_name = if table.is_a?(Focus::Table)
                   table.label || table.table_name
                 elsif table.is_a?(Focus::SelectTable)
                   table.alias
                 else
                   table.subquery_alias
                 end
    self.class.new(column_name: column_name, table_name: table_name)
  end

  # Generic greater-than operator that accepts any SQL expression (including other columns).
  def greater_than(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op(">", rhs)
  end

  def accept(visitor : SqlVisitor) : Nil
    visitor.visit_column(self)
  end
end
