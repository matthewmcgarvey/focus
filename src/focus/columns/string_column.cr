class Focus::StringColumn < Focus::Column
  def eq(value : String) : Focus::BoolExpression
    eq(Focus::GenericValueExpression(String).new(value))
  end

  def in_list(*vals : String) : Focus::BoolExpression
    _in_list(*vals)
  end
end
