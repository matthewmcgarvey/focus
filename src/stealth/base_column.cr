module Stealth::BaseColumn
  include Stealth::BaseColumnDeclaring

  getter table : Stealth::Table
  getter name : String

  abstract def as_expression : Stealth::BaseColumnExpression

  def label : String
    name
  end
end
