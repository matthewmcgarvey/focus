# class Focus::SelectQuery
#   include Focus::Queryable

#   getter expression : Focus::SelectExpression

#   def initialize(@expression : Focus::SelectExpression)
#   end

#   def to_sql : String
#     result = Focus.format_expression(expression)
#     result.first.strip
#   end

#   def format_expression : Tuple(String, Array(Focus::BaseArgumentExpression))
#     Focus.format_expression(expression)
#   end

#   def from(table : Focus::SubselectTable) : self
#     expression.from = table.subquery
#     self
#   end

#   def from(table : Focus::Table) : self
#     expression.from = table.as_expression
#     self
#   end

#   def where(condition : Focus::ScalarExpression(Bool)) : Focus::SelectQuery
#     expression.where = condition
#     self
#   end

#   # TODO: not even exactly sure what this is right now, but will need fixed
#   # def where_with_conditions(& : Array(ColumnDeclaring(Bool)) -> Nil) : Focus::SelectQuery
#   #   conditions = [] of ColumnDeclaring(Bool)
#   #   yield conditions
#   #   return self if conditions.empty?

#   #   condition = conditions.reduce { |a, b| a.and b }
#   #   where condition.as(Focus::ScalarExpression(Bool))
#   # end

#   # def where_with_or_conditions(& : Array(ColumnDeclaring(Bool)) -> Nil) : Focus::SelectQuery
#   #   conditions = [] of ColumnDeclaring(Bool)
#   #   yield conditions
#   #   return self if conditions.empty?

#   #   condition = conditions.reduce { |a, b| a.or b }
#   #   where condition.as(Focus::ScalarExpression(Bool))
#   # end

#   def group_by(*columns : BaseColumnDeclaring) : Focus::SelectQuery
#     group_by(columns.to_a)
#   end

#   def group_by(columns : Array(BaseColumnDeclaring)) : Focus::SelectQuery
#     expression.group_by = columns.map(&.as_expression.as(BaseScalarExpression))
#     self
#   end

#   def having(condition : ColumnDeclaring(Bool)) : Focus::SelectQuery
#     expression.having = condition.as_expression
#     self
#   end

#   def order_by(*orders : OrderByExpression) : Focus::SelectQuery
#     order_by(orders.to_a)
#   end

#   def order_by(orders : Array(OrderByExpression)) : Focus::SelectQuery
#     expression.order_by = orders
#     self
#   end

#   def limit(limit : Int32?) : Focus::SelectQuery
#     expression.limit = limit
#     self
#   end

#   def offset(offset : Int32?) : Focus::SelectQuery
#     expression.offset = offset
#     self
#   end

#   def distinct : Focus::SelectQuery
#     expression.is_distinct = true
#     self
#   end

#   def as_table(label : String) : Focus::Table
#     expression.table_alias = label
#     Focus::SubselectTable.new(expression)
#   end

#   def drop(n : Int32) : Focus::SelectQuery
#     if n > 0
#       offset = expression.offset || 0
#       expression.offset = offset + n
#     end
#     self
#   end

#   def take(n : Int32) : Focus::SelectQuery
#     limit = expression.limit || Int32::MAX
#     expression.limit = Math.min(limit, n)
#     self
#   end
# end
