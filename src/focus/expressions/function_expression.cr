class Focus::FunctionExpression < Focus::Expression
  getter name : String
  getter parameters : Array(Focus::Expression)

  def initialize(@name : String, @parameters : Array(Focus::Expression))
  end
end
