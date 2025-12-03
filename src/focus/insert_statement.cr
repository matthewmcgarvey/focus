# class Focus::InsertStatement
#   include Focus::Queryable

#   getter expression : Focus::InsertExpression

#   def initialize(@expression : Focus::InsertExpression)
#   end

#   def values(*values) : self
#     expression.arguments ||= Array(Array(BaseScalarExpression)).new
#     arguments = expression.arguments.not_nil!
#     row = Array(BaseScalarExpression).new
#     arguments << row
#     values.each do |arg|
#       row << Focus::ArgumentExpression.new(arg)
#     end
#     self
#   end

#   def query(query_statement : Focus::SelectQuery) : self
#     expression.query = query_statement.expression
#     self
#   end

#   def returning(*columns : Focus::BaseColumn) : self
#     expression.returning = columns.select(Focus::BaseColumn)
#     self
#   end

#   def format_expression : Tuple(String, Array(Focus::BaseArgumentExpression))
#     Focus.format_expression(expression)
#   end
# end
