module Stealth::Table
  abstract def table_name : String
  abstract def columns : Array(Stealth::BaseColumn)

  def as_expression : Stealth::TableExpression
    Stealth::TableExpression.new(name: table_name)
  end
end
