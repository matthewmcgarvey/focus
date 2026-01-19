class Focus::JsonbLiteral < Focus::JsonbExpression
  include Focus::Parameter

  getter value : JSON::Any

  def initialize(@value : JSON::Any)
  end
end
