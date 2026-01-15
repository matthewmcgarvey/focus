module Focus::PG::ToSql
  def to_sql
    visitor = Focus::PGFormatter.new
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_with_args : Tuple(String, Array(DB::Any))
    visitor = Focus::PGFormatter.new
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
