module Stealth::BaseColumnAssignmentExpression
  include Stealth::SqlExpression

  abstract def column : Stealth::BaseColumnExpression
  abstract def expression : Stealth::BaseScalarExpression
end

class Stealth::ColumnAssignmentExpression(T)
  include Stealth::BaseColumnAssignmentExpression

  getter column : Stealth::ColumnExpression(T)
  getter expression : Stealth::ScalarExpression(T)

  def initialize(@column, @expression)
  end
end
