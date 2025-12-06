require "./column_declaring"

abstract class Focus::Column < Focus::Expression
  getter table_name : String?
  getter name : String

  def initialize(@name : String, @table_name : String? = nil)
  end

  def asc : Focus::OrderByExpression
    Focus::OrderByExpression.new(self, Focus::OrderByExpression::OrderType::ASCENDING)
  end

  def desc : Focus::OrderByExpression
    Focus::OrderByExpression.new(self, Focus::OrderByExpression::OrderType::DESCENDING)
  end

  def from(table : Focus::Table | Focus::SubqueryExpression) : Focus::Column
    table_name = if table.is_a?(Focus::Table)
                   table.label || table.table_name
                 else
                   table.subquery_alias
                 end
    self.class.new(name: @name, table_name: table_name)
  end
end
