module Stealth::BaseColumnDeclaringExpression
  include Stealth::SqlExpression

  getter declared_name : String?
end

class Stealth::ColumnDeclaringExpression(T)
  include Stealth::BaseColumnDeclaringExpression
  include Stealth::ScalarExpression(T)

  getter expression : ScalarExpression(T)

  def initialize(@expression, @declared_name, @sql_type = expression.sql_type)
  end
end
