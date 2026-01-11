class Focus::IntColumn(INT_TYPE) < Focus::IntExpression(INT_TYPE)
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end
end
