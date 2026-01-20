module Focus::PG::ReadableTable
  def select(*fields : Focus::Expression | Array(Focus::Expression)) : Focus::PG::SelectStatement
    Focus::PG.select(*fields).from(self)
  end

  def select : Focus::PG::SelectStatement
    Focus::PG.select.from(self)
  end

  def lock : Focus::PG::LockStatement
    Focus::PG::LockStatement.new(self)
  end
end

module Focus::ReadableTable
  include Focus::PG::ReadableTable
end
