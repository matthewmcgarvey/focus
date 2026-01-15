module Focus::SQLite::ReadableTable
  def select(*fields : Focus::Expression | Array(Focus::Expression)) : Focus::SQLite::SelectStatement
    Focus::SQLite.select(*fields).from(self)
  end

  def select : Focus::SQLite::SelectStatement
    Focus::SQLite.select.from(self)
  end
end

module Focus::ReadableTable
  include Focus::SQLite::ReadableTable
end
