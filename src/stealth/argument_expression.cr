require "./base_argument_expression"
require "./scalar_expression"

class Stealth::ArgumentExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseArgumentExpression

  getter value : DB::Any

  def initialize(@value, @sql_type : DB::Any.class)
  end
end
