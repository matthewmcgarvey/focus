class Focus::SubqueryExpression < Focus::Expression
  include Focus::TableSource

  getter subquery : Focus::Statement
  getter subquery_alias : String?

  def initialize(@subquery : Focus::Statement, @subquery_alias : String? = nil)
  end
end
