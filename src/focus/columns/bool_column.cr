class Focus::BoolColumn < Focus::Column
  def eq(value : Bool) : Focus::BoolExpression
    eq(Focus::GenericValueExpression(Bool).new(value))
  end
end
