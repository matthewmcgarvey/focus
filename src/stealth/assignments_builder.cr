class Stealth::AssignmentsBuilder
  getter assignments = [] of Stealth::BaseColumnAssignmentExpression

  def set(column : Stealth::Column(T), value : T?) forall T
    assignments << Stealth::ColumnAssignmentExpression.new(column.as_expression, column.wrap_argument(value))
  end
end
