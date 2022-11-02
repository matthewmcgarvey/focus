module Stealth::Table
  abstract def table_name : String
  abstract def _columns : Array(Stealth::Column)

  def as_expression : Stealth::TableExpression
    Stealth::TableExpression.new(name: table_name)
  end
end
