module Stealth::BaseColumn
  getter table : Stealth::Table
  getter name : String

  abstract def as_expression : Stealth::BaseColumnExpression
end
