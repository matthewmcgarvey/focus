module Stealth::BaseColumnExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter name : String
end
