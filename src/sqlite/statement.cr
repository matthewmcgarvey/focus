abstract class Focus::SQLite::Statement < Focus::Statement
  def to_sql
    visitor = Focus::SQLiteFormatter.new
    accept(visitor)
    visitor.to_sql
  end

  def to_sql_with_args : Tuple(String, Array(DB::Any))
    visitor = Focus::SQLiteFormatter.new
    accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
