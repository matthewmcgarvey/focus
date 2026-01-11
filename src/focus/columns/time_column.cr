class Focus::TimeColumn < Focus::TimeExpression
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end

  def eq(value : Time) : Focus::BoolExpression
    eq(Focus::TimeLiteral.new(value))
  end
end
