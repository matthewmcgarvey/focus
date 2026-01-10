class Focus::IntColumn(INT_TYPE) < Focus::Column
  def eq(value : INT_TYPE) : Focus::BoolExpression
    eq(Focus::IntExpression(INT_TYPE).new(value))
  end

  def greater_than(value : INT_TYPE) : Focus::BoolExpression
    greater_than(Focus::IntExpression(INT_TYPE).new(value))
  end
end
