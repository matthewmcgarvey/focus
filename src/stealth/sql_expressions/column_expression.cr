class Stealth::ColumnExpression(T) < Stealth::BaseColumnExpression
  getter table : Stealth::TableExpression
  getter name : String
  getter sql_type : T.class

  def initialize(@table : Stealth::TableExpression, @name : String, @sql_type : T.class)
  end
end
