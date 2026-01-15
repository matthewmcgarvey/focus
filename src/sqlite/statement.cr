module Focus::SQLite::Statement
  def dialect : Focus::Dialect
    Focus::SQLiteDialect.new
  end
end
