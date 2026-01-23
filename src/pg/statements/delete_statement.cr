class Focus::PG::DeleteStatement < Focus::DeleteStatement
  include Focus::PG::Statement

  def using(table : Focus::ReadableTable) : self
    @using_clause = Focus::UsingClause.new(table)
    self
  end
end
