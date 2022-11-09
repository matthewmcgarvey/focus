require "./dsl/operators"

module Stealth::BaseColumnDeclaring
  abstract def as_declaring_expression : Stealth::BaseColumnDeclaringExpression
end

module Stealth::ColumnDeclaring(T)
  include Stealth::BaseColumnDeclaring
  include Stealth::Dsl::Operators(T)

  getter sql_type : T.class

  abstract def as_expression : Stealth::ScalarExpression(T)
  abstract def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
  abstract def aliased(label : String? = nil) : Stealth::ColumnDeclaringExpression(T)

  def asc : OrderByExpression
    OrderByExpression.new(as_expression, OrderType::ASCENDING)
  end

  def desc : OrderByExpression
    OrderByExpression.new(as_expression, OrderType::DESCENDING)
  end
end
