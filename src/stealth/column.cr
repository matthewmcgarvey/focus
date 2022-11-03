class Stealth::Column(T)
  include Stealth::BaseColumn

  getter sql_type : T.class

  def initialize(@table : Stealth::Table, @name : String, @sql_type : T.class)
  end

  def as_expression : Stealth::ColumnExpression(T)
    Stealth::ColumnExpression.new(table.as_expression, name, sql_type)
  end
end
