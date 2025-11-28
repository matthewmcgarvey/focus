class Focus::DeleteStatement
  include Focus::Queryable

  getter expression : Focus::DeleteExpression

  def initialize(@expression)
  end

  def format_expression : Tuple(String, Array(Focus::BaseArgumentExpression))
    Focus.format_expression(expression)
  end

  def where(condition : Focus::ScalarExpression(Bool)) : self
    expression.where = condition
    self
  end

  def returning(*columns : Focus::BaseColumn) : self
    expression.returning = columns.select(Focus::BaseColumn)
    self
  end

  def order_by(*orders : OrderByExpression) : self
    order_by(orders.to_a)
  end

  def order_by(orders : Array(OrderByExpression)) : self
    expression.order_by = orders
    self
  end

  def limit(limit : Int32?) : self
    expression.limit = limit
    self
  end

  def offset(offset : Int32?) : self
    expression.offset = offset
    self
  end
end
