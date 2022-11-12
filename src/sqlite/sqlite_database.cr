class Stealth::SQLiteDatabase < Stealth::Database
  def self.connect(url : String) : SQLiteDatabase
    new(raw_db: DB::Database.new(SQLite3::Driver.new, URI.parse(url)))
  end

  def self.connect(db : DB::Database) : SQLiteDatabase
    new(raw_db: db)
  end

  def format_expression(expression : Stealth::SqlExpression) : Tuple(String, Array(Stealth::BaseArgumentExpression))
    visitor = Stealth::SQLiteFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
