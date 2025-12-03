class Focus::SubqueryExpression < Focus::Expression
  include Focus::TableSource

  getter subquery : Focus::SelectStatement
  getter subquery_alias : String?

  def initialize(@subquery : Focus::SelectStatement, @subquery_alias : String? = nil)
  end
end
