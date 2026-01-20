module Focus::SQLite::Statements::Dsl::SetOperators
  def union(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:union, self, rhs)
  end

  def union_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:union_all, self, rhs)
  end

  def intersect(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:intersect, self, rhs)
  end

  def intersect_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:intersect_all, self, rhs)
  end

  def except(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:except, self, rhs)
  end

  def except_all(rhs : Focus::SelectStatement) : Focus::SetStatement
    Focus::SQLite::SetStatement.new(:except_all, self, rhs)
  end
end
