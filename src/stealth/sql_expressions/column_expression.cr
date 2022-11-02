class Stealth::ColumnExpression
  getter table : Stealth::TableExpression
  getter name : String

  def initialize(@table : Stealth::TableExpression, @name : String)
  end
end
