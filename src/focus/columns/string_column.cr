class Focus::StringColumn < Focus::Column
  scalar_wrappers(String, Focus::GenericValueExpression(String), :eq)

  def in_list(*vals : String) : Focus::BoolExpression
    _in_list(*vals)
  end
end
