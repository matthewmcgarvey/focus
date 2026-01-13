class Focus::FloatColumn(FLOAT_TYPE) < Focus::FloatExpression(FLOAT_TYPE)
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end
end
