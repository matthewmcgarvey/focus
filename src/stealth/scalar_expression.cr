require "./column_declaring"
require "./base_scalar_expression"

module Stealth::ScalarExpression(T)
  include Stealth::BaseScalarExpression
  include Stealth::ColumnDeclaring(T)

  def as_expression : Stealth::ScalarExpression(T)
    self
  end

  def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
    ArgumentExpression.new(argument, sql_type)
  end
end
