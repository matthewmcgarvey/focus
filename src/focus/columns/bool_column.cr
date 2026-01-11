class Focus::BoolColumn < Focus::BoolExpression
  include Focus::Column

  property table_name : String?
  getter column_name : String

  def initialize(@column_name : String, @table_name : String? = nil)
  end

  def eq(value : Bool) : Focus::BoolExpression
    eq(Focus::BoolLiteral.new(value))
  end
end
