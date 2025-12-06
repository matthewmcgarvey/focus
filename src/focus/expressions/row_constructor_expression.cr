class Focus::RowConstructorExpression < Focus::Expression
  getter values : Array(Focus::ValueExpression)

  def initialize(@values : Array(Focus::ValueExpression))
  end
end
