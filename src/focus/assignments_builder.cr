class Focus::AssignmentsBuilder
  getter assignments = [] of Focus::BaseColumnAssignmentExpression

  def set(column : Focus::Column(T), value : T?) forall T
    assignments << Focus::ColumnAssignmentExpression.new(column.as_expression, column.wrap_argument(value))
  end
end
