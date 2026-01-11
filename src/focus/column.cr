abstract class Focus::Column < Focus::Expression
  property table_name : String?
  getter column_name : String

  def initialize(@column_name : String, @table_name : String? = nil)
  end

  def asc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::ASCENDING)
  end

  def desc : Focus::OrderByClause
    Focus::OrderByClause.new(self, Focus::OrderByClause::OrderType::DESCENDING)
  end

  def from(table : Focus::ReadableTable) : Focus::Column
    table_name = if table.is_a?(Focus::Table)
                   table.label || table.table_name
                 elsif table.is_a?(Focus::SelectTable)
                   table.alias
                 else
                   table.subquery_alias
                 end
    self.class.new(column_name: @column_name, table_name: table_name)
  end

  # Helper to build simple binary boolean expressions for this column.
  def binary_op(operator : String, rhs : Focus::Expression) : Focus::BoolExpression
    expression = Focus::BinaryExpression.new(left: self, right: rhs, operator: operator)
    Focus::BoolExpression.new(expression)
  end

  # Generic equality operator that accepts any SQL expression (including other columns).
  def eq(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op("=", rhs)
  end

  # Generic greater-than operator that accepts any SQL expression (including other columns).
  def greater_than(rhs : Focus::Expression) : Focus::BoolExpression
    binary_op(">", rhs)
  end
end
