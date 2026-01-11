class Focus::UpdateClause < Focus::Clause
  getter table : Focus::ReadableTable

  def initialize(@table : Focus::ReadableTable)
  end
end
