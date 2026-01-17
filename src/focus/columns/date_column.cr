class Focus::DateColumn < Focus::DateExpression
  include Focus::Column

  def initialize(@column_name : String, @table_name : String? = nil)
  end
end
