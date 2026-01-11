class Focus::IntColumn(INT_TYPE) < Focus::IntExpression(INT_TYPE)
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end

  def eq(value : INT_TYPE) : Focus::BoolExpression
    eq(Focus::IntLiteral(INT_TYPE).new(value))
  end

  def greater_than(value : INT_TYPE) : Focus::BoolExpression
    greater_than(Focus::IntLiteral(INT_TYPE).new(value))
  end
end
