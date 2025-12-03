module Focus::Joinable
  abstract def as_table_source : Focus::TableSource

  def join(right : Focus::TableSource | Focus::Table, on : Focus::BoolExpression? = nil) : Focus::JoinExpression
    Focus::JoinExpression.new(
      left: as_table_source,
      right: right.as_table_source,
      join_type: Focus::JoinExpression::JoinType::INNER,
      condition: on
    )
  end

  def inner_join(right : Focus::TableSource | Focus::Table, on : Focus::BoolExpression? = nil) : Focus::JoinExpression
    join(right, on)
  end

  def left_join(right : Focus::TableSource | Focus::Table, on : Focus::BoolExpression? = nil) : Focus::JoinExpression
    Focus::JoinExpression.new(
      left: as_table_source,
      right: right.as_table_source,
      join_type: Focus::JoinExpression::JoinType::LEFT,
      condition: on
    )
  end

  def right_join(right : Focus::TableSource | Focus::Table, on : Focus::BoolExpression? = nil) : Focus::JoinExpression
    Focus::JoinExpression.new(
      left: as_table_source,
      right: right.as_table_source,
      join_type: Focus::JoinExpression::JoinType::RIGHT,
      condition: on
    )
  end

  def cross_join(right : Focus::TableSource | Focus::Table, on : Focus::BoolExpression? = nil) : Focus::JoinExpression
    Focus::JoinExpression.new(
      left: as_table_source,
      right: right.as_table_source,
      join_type: Focus::JoinExpression::JoinType::CROSS,
      condition: on
    )
  end
end
