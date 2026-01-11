class Focus::OrderByClause < Focus::Clause
  enum OrderType
    ASCENDING
    DESCENDING
  end
  getter expression : Focus::Expression
  getter order_type : OrderType
  getter is_nulls_first : Bool?

  def initialize(@expression : Focus::Expression, @order_type : OrderType)
  end

  def nulls_first : self
    @is_nulls_first = true
    self
  end

  def nulls_last : self
    @is_nulls_first = false
    self
  end
end
