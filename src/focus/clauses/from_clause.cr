class Focus::FromClause < Focus::Clause
  getter table_source : Focus::TableSource

  def initialize(@table_source : Focus::TableSource)
  end
end
