module Stealth::BaseColumnExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression?
  getter name : String

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::ColumnExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseColumnExpression

  def initialize(@table, @name, @sql_type)
  end

  def initialize(@name, @sql_type)
    @table = nil
  end
end
