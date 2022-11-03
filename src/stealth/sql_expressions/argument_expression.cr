class Stealth::ArgumentExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseArgumentExpression

  getter value : T

  def initialize(@value, @sql_type)
  end
end
