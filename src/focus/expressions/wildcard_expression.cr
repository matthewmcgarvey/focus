class Focus::WildcardExpression < Focus::Expression
  getter table_name : String?

  def initialize(@table_name : String? = nil)
  end
end
