require "./dsl/operators"

module Focus::BaseColumnDeclaring
  abstract def as_declaring_expression : Focus::BaseColumnDeclaringExpression
end

module Focus::ColumnDeclaring(T)
  include Focus::BaseColumnDeclaring
  include Focus::Dsl::Operators(T)

  abstract def as_expression : Focus::ScalarExpression(T)
  abstract def wrap_argument(argument : T?) : Focus::ArgumentExpression(T)
  abstract def aliased(label : String? = nil) : Focus::ColumnDeclaringExpression(T)

  def asc : OrderByExpression
    OrderByExpression.new(as_expression, OrderType::ASCENDING)
  end

  def desc : OrderByExpression
    OrderByExpression.new(as_expression, OrderType::DESCENDING)
  end

  def sql_type
    T
  end
end
