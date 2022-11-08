class Stealth::InListExpression(T)
  include Stealth::ScalarExpression(Bool)

  getter left : ScalarExpression(T)
  getter query : QueryExpression?
  getter values : Array(ScalarExpression(T))?
  getter not_in_list : Bool

  def initialize(@left, @query = nil, @values = nil, @not_in_list = false)
    @sql_type = Bool
  end
end
