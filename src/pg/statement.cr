module Focus::PG::Statement
  def dialect : Focus::Dialect
    Focus::PGDialect.new
  end
end
