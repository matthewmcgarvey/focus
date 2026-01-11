class Focus::DeleteClause < Focus::Clause
  getter table : Focus::ReadableTable

  def initialize(@table : Focus::ReadableTable)
  end
end
