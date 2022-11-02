class Stealth::Column
  getter table : Stealth::Table
  getter name : String

  def initialize(@table : Stealth::Table, @name : String)
  end

  def as_expression : Stealth::ColumnExpression
    Stealth::ColumnExpression.new(table.as_expression, name)
  end
end
