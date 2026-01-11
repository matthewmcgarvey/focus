class Focus::InsertClause < Focus::Clause
  getter table : Focus::ReadableTable
  getter columns : Array(Focus::ColumnToken)

  def initialize(@table : Focus::ReadableTable, @columns : Array(Focus::ColumnToken))
  end
end
