class Focus::InsertOrUpdateExpression
  include Focus::SqlExpression

  getter table : Focus::TableExpression
  getter assignments : Array(BaseColumnAssignmentExpression)
  getter conflict_columns : Array(BaseColumnExpression)
  getter update_assignments : Array(BaseColumnAssignmentExpression)
  getter returning_columns : Array(BaseColumnExpression)

  def initialize(
    @table,
    @assignments,
    @conflict_columns = [] of BaseColumnExpression,
    @update_assignments = [] of BaseColumnAssignmentExpression,
    @returning_columns = [] of BaseColumnExpression,
  )
  end
end
