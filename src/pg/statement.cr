module Focus::PG::Statement
  def dialect : Focus::Dialect
    Focus::PG::Dialect.new
  end
end
