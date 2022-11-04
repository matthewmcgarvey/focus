module Stealth::Table
  abstract def table_name : String
  abstract def _columns : Array(Stealth::BaseColumn)

  def as_expression : Stealth::TableExpression
    Stealth::TableExpression.new(name: table_name)
  end

  def columns : Array(Stealth::BaseColumn)
    _columns
  end
end
