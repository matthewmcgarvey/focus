class Stealth::BetweenExpression(T)
  include Stealth::ScalarExpression(Bool)

  getter expression : Stealth::ScalarExpression(T)
  getter lower : Stealth::ScalarExpression(T)
  getter upper : Stealth::ScalarExpression(T)

  def initialize(@expression, @lower, @upper)
    @sql_type = Bool
  end
end
