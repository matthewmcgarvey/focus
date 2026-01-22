class Focus::JoinTable
  include Focus::ReadableTable
  include Focus::SerializableTable

  enum JoinType
    INNER
    LEFT
    RIGHT
    CROSS
  end

  getter lhs : Focus::ReadableTable
  getter rhs : Focus::ReadableTable
  getter join_type : JoinType
  getter condition : BoolExpression?

  def initialize(@lhs, @rhs, @join_type, @condition)
  end
end
