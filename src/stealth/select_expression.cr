class Stealth::SelectExpression
  include Stealth::QueryExpression

  getter columns : Array(BaseColumnDeclaringExpression)
  getter from : QuerySourceExpression
  getter where : ScalarExpression(Bool)?
  getter group_by : Array(BaseScalarExpression)
  getter having : ScalarExpression(Bool)?
  getter order_by : Array(OrderByExpression)
  getter is_distinct : Bool
  getter limit : Int32?
  getter offset : Int32?

  def initialize(
    @from,
    @columns = [] of BaseColumnDeclaringExpression,
    @where = nil,
    @group_by = [] of BaseScalarExpression,
    @having = nil,
    @order_by = [] of OrderByExpression,
    @is_distinct = false,
    @limit = nil,
    @offset = nil
  )
  end

  def copy(
    columns = self.columns,
    from = self.from,
    where = self.where,
    group_by = self.group_by,
    having = self.having,
    order_by = self.order_by,
    is_distinct = self.is_distinct,
    limit = self.limit,
    offset = self.offset
  )
    SelectExpression.new(
      from,
      columns,
      where,
      group_by,
      having,
      order_by,
      is_distinct,
      limit,
      offset
    )
  end
end
