struct Stealth::ColumnExpression(T)
  include Stealth::BaseColumnExpression

  getter sql_type : T.class

  def initialize(@table : Stealth::TableExpression, @name : String, @sql_type : T.class)
  end
end
