class Focus::FunctionExpression < Focus::Expression
  getter name : String
  getter! parameters : Array(Focus::Expression)
  getter no_brackets : Bool

  def initialize(@name : String, @parameters : Array(Focus::Expression)? = nil, @no_brackets : Bool = false)
  end
end
