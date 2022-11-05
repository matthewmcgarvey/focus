class Stealth::TableExpression
  include Stealth::SqlExpression

  getter name : String

  def initialize(@name : String)
  end
end
