require "./scalar_expression"

class Stealth::AggregateExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::AggregateType
  getter argument : Stealth::BaseScalarExpression?
  getter is_distinct : Bool

  def initialize(@type, @argument, @is_distinct, @sql_type)
  end

  def method : String
    type.method
  end
end

enum Stealth::AggregateType
  MIN
  MAX
  AVG
  SUM
  COUNT

  def method : String
    case self
    when MIN
      "min"
    when MAX
      "max"
    when AVG
      "avg"
    when SUM
      "sum"
    when COUNT
      "count"
    else
      raise "missing a case statement for #{self}"
    end
  end
end
