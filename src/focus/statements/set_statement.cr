abstract class Focus::SetStatement < Focus::Statement
  getter operator : SetOperator
  getter lhs : Focus::SelectStatement
  getter rhs : Focus::SelectStatement
  property order_by_clauses : Focus::OrderByListClause?
  property limit_clause : Focus::LimitClause?
  property offset_clause : Focus::OffsetClause?

  enum SetOperator
    UNION
    UNION_ALL
    INTERSECT
    INTERSECT_ALL
    EXCEPT
    EXCEPT_ALL
  end

  def initialize(@operator : SetOperator, @lhs : Focus::SelectStatement, @rhs : Focus::SelectStatement)
  end

  def order_by(*clauses : Focus::OrderByClause) : self
    self.order_by_clauses ||= Focus::OrderByListClause.new
    if list = self.order_by_clauses
      clauses.each do |clause|
        list.order_bys << clause
      end
    end
    self
  end

  def limit(limit : Int32) : self
    @limit_clause = Focus::LimitClause.new(limit)
    self
  end

  def offset(offset : Int32) : self
    @offset_clause = Focus::OffsetClause.new(offset)
    self
  end

  def aliased(label : String) : Focus::SelectTable
    Focus::SelectTable.new(self, label)
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::SET_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    raise "this shouldn't be called"
  end
end
