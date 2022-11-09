class Stealth::ExistsExpression
  include Stealth::ScalarExpression(Bool)

  getter query : QueryExpression
  getter not_exists : Bool

  def initialize(@query, @not_exists = false)
    @sql_type = Bool
  end
end
