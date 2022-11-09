class Stealth::SelectExpression
  include Stealth::QueryExpression

  getter columns : Array(BaseColumnDeclaringExpression)
  getter from : QuerySourceExpression
  getter where : ScalarExpression(Bool)?
  getter group_by : Array(BaseScalarExpression)
  getter is_distinct : Bool

  def initialize(
    @from,
    @columns = [] of BaseColumnDeclaringExpression,
    @where = nil,
    @group_by = [] of BaseScalarExpression,
    @is_distinct = false
  )
  end
end
