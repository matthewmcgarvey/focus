# class Focus::ILikeExpression
#   include ScalarExpression(Bool)

#   getter left : BaseScalarExpression
#   getter right : BaseScalarExpression

#   def initialize(@left, @right)
#   end
# end

# module Focus::ColumnDeclaring(T)
#   def i_like(expr : ColumnDeclaring(String)) : ILikeExpression
#     ILikeExpression.new(as_expression, expr.as_expression)
#   end

#   def i_like(argument : String) : ILikeExpression
#     i_like(ArgumentExpression.new(argument, String))
#   end
# end
