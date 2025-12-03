# module Focus::BaseScalarExpression
#   include Focus::SqlExpression
# end

# module Focus::ScalarExpression(T)
#   include Focus::BaseScalarExpression
#   include Focus::ColumnDeclaring(T)

#   def as_expression : self
#     self
#   end

#   def wrap_argument(argument : T?) : Focus::ArgumentExpression(T)
#     ArgumentExpression(T).new(argument)
#   end

#   def aliased(label : String? = nil) : Focus::ColumnDeclaringExpression(T)
#     Focus::ColumnDeclaringExpression.new(self, label)
#   end

#   def as_declaring_expression : Focus::ColumnDeclaringExpression(T)
#     aliased(nil)
#   end
# end

# module Focus::QuerySourceExpression
#   include Focus::SqlExpression
# end

# module Focus::QueryExpression
#   include Focus::QuerySourceExpression

#   getter table_alias : String?
# end

# class Focus::TableExpression
#   include Focus::QuerySourceExpression

#   getter name : String
#   getter table_alias : String?
#   getter catalog : String?
#   getter schema : String?
#   getter joins : Array(Focus::JoinExpression)?

#   def initialize(@name, @table_alias = nil, @catalog = nil, @schema = nil, @joins = nil)
#   end

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# class Focus::SelectExpression
#   include Focus::QueryExpression

#   property columns : Array(BaseColumnDeclaringExpression)?
#   property from : QuerySourceExpression?
#   property where : ScalarExpression(Bool)?
#   property group_by : Array(BaseScalarExpression)?
#   property having : ScalarExpression(Bool)?
#   property order_by : Array(OrderByExpression)?
#   property is_distinct : Bool = false
#   property limit : Int32?
#   property offset : Int32?
#   property table_alias : String?
# end

# class Focus::AggregateExpression(T)
#   include Focus::ScalarExpression(T)

#   getter type : Focus::AggregateType
#   getter argument : Focus::BaseScalarExpression?
#   getter is_distinct : Bool

#   def initialize(@type, @argument, @is_distinct)
#   end

#   def method : String
#     type.method
#   end

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# enum Focus::AggregateType
#   MIN
#   MAX
#   AVG
#   SUM
#   COUNT

#   def method : String
#     case self
#     when MIN
#       "min"
#     when MAX
#       "max"
#     when AVG
#       "avg"
#     when SUM
#       "sum"
#     when COUNT
#       "count"
#     else
#       raise "missing a case statement for #{self}"
#     end
#   end
# end

# module Focus::BaseArgumentExpression
#   abstract def value
# end

# class Focus::ArgumentExpression(T)
#   include Focus::ScalarExpression(T)
#   include Focus::BaseArgumentExpression

#   getter value : T?

#   def initialize(@value)
#   end

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# class Focus::BetweenExpression(T)
#   include Focus::ScalarExpression(Bool)

#   getter expression : Focus::ScalarExpression(T)
#   getter lower : Focus::ScalarExpression(T)
#   getter upper : Focus::ScalarExpression(T)
#   getter not_between : Bool

#   def initialize(@expression, @lower, @upper, @not_between = false)
#   end

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# class Focus::BinaryExpression(T, V)
#   include Focus::ScalarExpression(T)

#   getter type : Focus::BinaryExpressionType
#   getter left : Focus::ScalarExpression(V)
#   getter right : Focus::ScalarExpression(V)

#   def initialize(@type, @left, @right)
#   end

#   def operator : String
#     type.operator
#   end
# end

# enum Focus::BinaryExpressionType
#   PLUS
#   MINUS
#   TIMES
#   DIV
#   REM
#   LIKE
#   NOT_LIKE
#   AND
#   OR
#   XOR
#   LESS_THAN
#   LESS_THAN_OR_EQUAL
#   GREATER_THAN
#   GREATER_THAN_OR_EQUAL
#   EQUAL
#   NOT_EQUAL

#   def operator : String
#     case self
#     when PLUS
#       "+"
#     when MINUS
#       "-"
#     when TIMES
#       "*"
#     when DIV
#       "/"
#     when REM
#       "%"
#     when LIKE
#       "like"
#     when NOT_LIKE
#       "not like"
#     when AND
#       "and"
#     when OR
#       "or"
#     when XOR
#       "xor"
#     when LESS_THAN
#       "<"
#     when LESS_THAN_OR_EQUAL
#       "<="
#     when GREATER_THAN
#       ">"
#     when GREATER_THAN_OR_EQUAL
#       ">="
#     when EQUAL
#       "="
#     when NOT_EQUAL
#       "<>"
#     else
#       raise "missing a case statement for #{self}"
#     end
#   end
# end

# module Focus::BaseColumnExpression
#   include Focus::SqlExpression

#   getter table_name : String?
#   getter name : String

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# class Focus::ColumnExpression(T)
#   include Focus::ScalarExpression(T)
#   include Focus::BaseColumnExpression

#   def initialize(@name, @table_name)
#   end
# end

# module Focus::BaseColumnDeclaringExpression
#   include Focus::SqlExpression

#   getter declared_name : String?

#   def wrap_in_parens? : Bool
#     false
#   end
# end

# class Focus::ColumnDeclaringExpression(T)
#   include Focus::ScalarExpression(T)
#   include Focus::BaseColumnDeclaringExpression

#   getter expression : ScalarExpression(T)

#   def initialize(@expression, @declared_name)
#   end

#   def as_declaring_expression : Focus::ColumnDeclaringExpression(T)
#     self
#   end
# end

# module Focus::BaseColumnAssignmentExpression
#   include Focus::SqlExpression

#   abstract def column : Focus::BaseColumnExpression
#   abstract def expression : Focus::BaseScalarExpression?
#   abstract def query : Focus::SelectExpression?
# end

# class Focus::ColumnAssignmentExpression(T)
#   include Focus::BaseColumnAssignmentExpression

#   getter column : Focus::ColumnExpression(T)
#   getter expression : Focus::ScalarExpression(T)?
#   getter query : Focus::SelectExpression?

#   def initialize(@column, @expression = nil, @query = nil)
#   end
# end

# class Focus::DeleteExpression
#   include Focus::SqlExpression
#   getter table : Focus::Table
#   property where : ScalarExpression(Bool)?
#   property returning : Array(BaseColumn)?
#   property order_by : Array(OrderByExpression)?
#   property limit : Int32?
#   property offset : Int32?

#   def initialize(@table)
#   end
# end

# class Focus::ExistsExpression
#   include Focus::ScalarExpression(Bool)

#   getter query : QueryExpression
#   getter not_exists : Bool

#   def initialize(@query, @not_exists = false)
#   end
# end

# class Focus::InListExpression(T)
#   include Focus::ScalarExpression(Bool)

#   getter left : ScalarExpression(T)
#   getter query : QueryExpression?
#   getter values : Array(ArgumentExpression(T))?
#   getter not_in_list : Bool

#   def initialize(@left, @query = nil, @values = nil, @not_in_list = false)
#   end
# end

# class Focus::InsertExpression
#   include Focus::SqlExpression

#   getter table : Focus::Table
#   getter columns : Array(Focus::BaseColumn)
#   property arguments : Array(Array(BaseScalarExpression))?
#   property query : SelectExpression?
#   property returning : Array(Focus::BaseColumn)?

#   def initialize(@table : Focus::Table, @columns : Array(Focus::BaseColumn))
#   end
# end

# class Focus::JoinExpression
#   include Focus::QuerySourceExpression

#   getter type : JoinType
#   getter join_table : Table
#   getter condition : ScalarExpression(Bool)?

#   def initialize(@type, @join_table, @condition = nil)
#   end

#   def join_type : String
#     type.join_type
#   end
# end

# enum Focus::JoinType
#   CROSS_JOIN
#   INNER_JOIN
#   LEFT_JOIN
#   RIGHT_JOIN

#   def join_type : String
#     case self
#     when CROSS_JOIN
#       "cross join"
#     when INNER_JOIN
#       "inner join"
#     when LEFT_JOIN
#       "left join"
#     when RIGHT_JOIN
#       "right join"
#     else
#       raise "missing a case statement for #{self}"
#     end
#   end
# end

# class Focus::OrderByExpression
#   include Focus::SqlExpression

#   getter expression : BaseScalarExpression
#   getter order_type : OrderType

#   def initialize(@expression, @order_type)
#   end

#   def order : String
#     order_type.order
#   end
# end

# enum Focus::OrderType
#   ASCENDING
#   DESCENDING

#   def order : String
#     case self
#     when ASCENDING
#       "asc"
#     when DESCENDING
#       "desc"
#     else
#       raise "missing a case statement for #{self}"
#     end
#   end
# end

# class Focus::UnaryExpression(T)
#   include Focus::ScalarExpression(T)

#   getter type : Focus::UnaryExpressionType
#   getter operand : Focus::BaseScalarExpression

#   def initialize(@type, @operand)
#   end

#   def operator : String
#     type.operator
#   end
# end

# enum Focus::UnaryExpressionType
#   IS_NULL
#   IS_NOT_NULL
#   UNARY_MINUS
#   UNARY_PLUS
#   NOT

#   def operator : String
#     case self
#     when IS_NULL
#       "is null"
#     when IS_NOT_NULL
#       "is not null"
#     when UNARY_MINUS
#       "-"
#     when UNARY_PLUS
#       "+"
#     when NOT
#       "not"
#     else
#       raise "missing a case statement for #{self}"
#     end
#   end
# end

# class Focus::UpdateExpression
#   include Focus::SqlExpression

#   getter table : Focus::Table
#   getter assignments : Array(BaseColumnAssignmentExpression)?
#   property where : ScalarExpression(Bool)?
#   property returning : Array(BaseColumn)?

#   def initialize(@table)
#   end

#   def add_assignment(assignment : BaseColumnAssignmentExpression)
#     arr = @assignments ||= Array(BaseColumnAssignmentExpression).new
#     arr << assignment
#   end
# end
