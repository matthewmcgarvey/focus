# class Focus::UpdateStatement
#   include Focus::Queryable

#   getter expression : Focus::UpdateExpression

#   def initialize(@expression : Focus::UpdateExpression)
#   end

#   def format_expression : Tuple(String, Array(Focus::BaseArgumentExpression))
#     Focus.format_expression(expression)
#   end

#   def set(column : Focus::Column(T), val : T) : self forall T
#     expr = ColumnAssignmentExpression(T).new(column.as_expression, expression: column.wrap_argument(val))
#     expression.add_assignment(expr)
#     self
#   end

#   def set(column : Focus::Column(T), query : SelectQuery) : self forall T
#     expr = ColumnAssignmentExpression(T).new(column.as_expression, query: query.expression)
#     expression.add_assignment(expr)
#     self
#   end

#   def where(condition : Focus::ScalarExpression(Bool)) : self
#     expression.where = condition
#     self
#   end

#   def returning(*columns : Focus::BaseColumn) : self
#     expression.returning = columns.select(Focus::BaseColumn)
#     self
#   end
# end
