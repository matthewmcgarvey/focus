module Focus::PG::Statements::Dsl::SetOperators
  def union(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:union, self, rhs)
  end

  def union_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:union_all, self, rhs)
  end

  def intersect(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:intersect, self, rhs)
  end

  def intersect_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:intersect_all, self, rhs)
  end

  def except(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:except, self, rhs)
  end

  def except_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::PG::SetStatement.new(:except_all, self, rhs)
  end
end
