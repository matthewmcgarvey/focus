abstract class Stealth::BaseColumn
  getter table : Stealth::Table
  getter name : String

  def initialize(@table : Stealth::Table, @name : String)
  end

  abstract def as_expression : Stealth::BaseColumnExpression
end
