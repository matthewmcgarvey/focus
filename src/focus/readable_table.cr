module Focus::ReadableTable
  def join(right : Focus::ReadableTable, on : Focus::BoolExpression? = nil) : Focus::JoinTable
    inner_join(right, on)
  end

  def inner_join(right : Focus::ReadableTable, on : Focus::BoolExpression? = nil) : Focus::JoinTable
    Focus::JoinTable.new(
      lhs: self,
      rhs: right,
      join_type: Focus::JoinTable::JoinType::INNER,
      condition: on
    )
  end

  def left_join(right : Focus::ReadableTable, on : Focus::BoolExpression? = nil) : Focus::JoinTable
    Focus::JoinTable.new(
      lhs: self,
      rhs: right,
      join_type: Focus::JoinTable::JoinType::LEFT,
      condition: on
    )
  end

  def right_join(right : Focus::ReadableTable, on : Focus::BoolExpression? = nil) : Focus::JoinTable
    Focus::JoinTable.new(
      lhs: self,
      rhs: right,
      join_type: Focus::JoinTable::JoinType::RIGHT,
      condition: on
    )
  end

  def cross_join(right : Focus::ReadableTable, on : Focus::BoolExpression? = nil) : Focus::JoinTable
    Focus::JoinTable.new(
      lhs: self,
      rhs: right,
      join_type: Focus::JoinTable::JoinType::CROSS,
      condition: on
    )
  end
end
