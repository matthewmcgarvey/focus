module Stealth::BaseColumnExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter name : String
end

class Stealth::ColumnExpression(T)
  include Stealth::BaseColumnExpression
  include Stealth::ScalarExpression(T)

  def initialize(@table : Stealth::TableExpression, @name : String, @sql_type : T.class)
  end
end
