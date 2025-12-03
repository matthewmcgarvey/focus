class Focus::OrderByExpression < Focus::Expression
  enum OrderType
    ASCENDING
    DESCENDING
  end

  getter inner : Focus::Expression
  getter order_type : OrderType

  def initialize(@inner : Focus::Expression, @order_type : OrderType)
  end
end
