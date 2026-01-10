class Focus::TimeColumn < Focus::Column
  def eq(value : Time) : Focus::BoolExpression
    eq(Focus::GenericValueExpression(Time).new(value))
  end
end
