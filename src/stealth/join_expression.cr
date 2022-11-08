require "./query_source_expression"

class Stealth::JoinExpression
  include Stealth::QuerySourceExpression

  getter type : JoinType
  getter left : QuerySourceExpression
  getter right : QuerySourceExpression
  getter condition : ScalarExpression(Bool)?

  def initialize(@type, @left, @right, @condition = nil)
  end

  def join_type : String
    type.join_type
  end
end

enum Stealth::JoinType
  CROSS_JOIN
  INNER_JOIN
  LEFT_JOIN
  RIGHT_JOIN

  def join_type : String
    case self
    when CROSS_JOIN
      "cross join"
    when INNER_JOIN
      "inner join"
    when LEFT_JOIN
      "left join"
    when RIGHT_JOIN
      "right join"
    else
      raise "missing a case statement for #{self}"
    end
  end
end
