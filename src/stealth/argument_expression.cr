require "./scalar_expression"

module Stealth::BaseArgumentExpression
  abstract def value : DB::Any
end

class Stealth::ArgumentExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseArgumentExpression

  getter value : DB::Any

  def initialize(@value, @sql_type)
  end
end
