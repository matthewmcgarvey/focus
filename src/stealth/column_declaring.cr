module Stealth::ColumnDeclaring(T)
  getter sql_type : T.class

  abstract def as_expression : Stealth::ScalarExpression(T)
  abstract def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
end
