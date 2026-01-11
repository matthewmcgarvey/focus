class Focus::StringLiteral < Focus::StringExpression
  include Focus::Parameter

  getter value : String

  def initialize(@value : String)
  end
end
