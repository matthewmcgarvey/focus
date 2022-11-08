class Stealth::BetweenExpression(T)
  include Stealth::ScalarExpression(Bool)

  getter expression : Stealth::ScalarExpression(T)
  getter lower : Stealth::ScalarExpression(T)
  getter upper : Stealth::ScalarExpression(T)
  getter not_between : Bool

  def initialize(@expression, @lower, @upper, @not_between = false)
    @sql_type = Bool
  end

  def wrap_in_parens? : Bool
    false
  end
end
