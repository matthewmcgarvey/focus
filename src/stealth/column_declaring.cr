require "./dsl/operators"
require "./base_column_declaring"

module Stealth::ColumnDeclaring(T)
  include Stealth::BaseColumnDeclaring
  include Stealth::Dsl::Operators(T)

  getter sql_type : T.class

  abstract def as_expression : Stealth::ScalarExpression(T)
  abstract def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
  abstract def aliased(label : String? = nil) : Stealth::ColumnDeclaringExpression(T)
end
