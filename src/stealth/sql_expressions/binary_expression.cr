class Stealth::BinaryExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::BinaryExpressionType
  getter left : Stealth::BaseScalarExpression
  getter right : Stealth::BaseScalarExpression

  def initialize(@type, @left, @right, @sql_type)
  end

  def operator : String
    type.operator
  end
end

enum Stealth::BinaryExpressionType
  PLUS
  MINUS
  TIMES
  DIV
  REM
  LIKE
  NOT_LIKE
  AND
  OR
  XOR
  LESS_THAN
  LESS_THAN_OR_EQUAL
  GREATER_THAN
  GREATER_THAN_OR_EQUAL
  EQUAL
  NOT_EQUAL

  def operator : String
    case self
    when PLUS
      "+"
    when MINUS
      "-"
    when TIMES
      "*"
    when DIV
      "/"
    when REM
      "%"
    when LIKE
      "like"
    when NOT_LIKE
      "not like"
    when AND
      "and"
    when OR
      "or"
    when XOR
      "xor"
    when LESS_THAN
      "<"
    when LESS_THAN_OR_EQUAL
      "<="
    when GREATER_THAN
      ">"
    when GREATER_THAN_OR_EQUAL
      ">="
    when EQUAL
      "="
    when NOT_EQUAL
      "<>"
    else
      raise "missing a case statement for #{self}"
    end
  end
end
