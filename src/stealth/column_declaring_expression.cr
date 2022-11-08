module Stealth::BaseColumnDeclaringExpression
  include Stealth::SqlExpression

  getter declared_name : String?

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::ColumnDeclaringExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseColumnDeclaringExpression

  getter expression : ScalarExpression(T)

  def initialize(@expression, @declared_name, @sql_type = expression.sql_type)
  end
end
