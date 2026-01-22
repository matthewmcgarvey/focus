class Focus::ArrayColumn(T) < Focus::ArrayExpression(T)
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end
end
