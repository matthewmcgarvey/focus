module Focus::SQLite::Statement
  def dialect : Focus::Dialect
    Focus::SQLite::Dialect.new
  end
end
