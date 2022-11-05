class Stealth::UnaryExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::UnaryExpressionType
  getter operand : Stealth::BaseScalarExpression

  def initialize(@type, @operand, @sql_type)
  end

  def operator : String
    type.operator
  end
end

enum Stealth::UnaryExpressionType
  IS_NULL
  IS_NOT_NULL
  UNARY_MINUS
  UNARY_PLUS
  NOT

  def operator : String
    case self
    when IS_NULL
      "is null"
    when IS_NOT_NULL
      "is not null"
    when UNARY_MINUS
      "-"
    when UNARY_PLUS
      "+"
    when NOT
      "not"
    else
      raise "missing a case statement for #{self}"
    end
  end
end
