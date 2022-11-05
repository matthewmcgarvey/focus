class Stealth::ArgumentExpression
  include Stealth::ScalarExpression(DB::Any)
  include Stealth::BaseArgumentExpression

  getter value : DB::Any

  def initialize(@value)
    @sql_type = DB::Any
  end
end
