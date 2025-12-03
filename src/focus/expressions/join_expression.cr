class Focus::JoinExpression < Focus::Expression
  include Focus::TableSource

  enum JoinType
    INNER
    LEFT
    RIGHT
    CROSS
  end

  getter left : Focus::TableSource
  getter right : Focus::TableSource
  getter join_type : JoinType
  getter condition : Expression?

  def initialize(@left : Focus::TableSource, @right : Focus::TableSource, @join_type : JoinType, @condition : Expression? = nil)
  end
end
