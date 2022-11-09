class Stealth::OrderByExpression
  include Stealth::SqlExpression

  getter expression : BaseScalarExpression
  getter order_type : OrderType

  def initialize(@expression, @order_type)
  end

  def order : String
    order_type.order
  end
end

enum Stealth::OrderType
  ASCENDING
  DESCENDING

  def order : String
    case self
    when ASCENDING
      "asc"
    when DESCENDING
      "desc"
    else
      raise "missing a case statement for #{self}"
    end
  end
end
