class Focus::PG::DeleteStatement < Focus::DeleteStatement
  include Focus::PG::Statement

  def using(table : Focus::ReadableTable) : self
    @using = Focus::UsingClause.new(table)
    self
  end
end
