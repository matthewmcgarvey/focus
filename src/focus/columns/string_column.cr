class Focus::StringColumn < Focus::StringExpression
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end

  def eq(value : String) : Focus::BoolExpression
    eq(Focus::StringLiteral.new(value))
  end

  def in_list(*vals : String) : Focus::BoolExpression
    _in_list(*vals)
  end
end
