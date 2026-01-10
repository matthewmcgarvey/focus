class Focus::QueryClause < Focus::Clause
  getter query : Focus::Statement

  def initialize(@query : Focus::Statement)
  end
end
