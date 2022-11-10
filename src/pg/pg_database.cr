class Stealth::PGDatabase < Stealth::Database
  def self.connect(url : String) : PGDatabase
    new(raw_db: DB::Database.new(PG::Driver.new, URI.parse(url)))
  end

  def self.connect(db : DB::Database) : PGDatabase
    new(raw_db: db)
  end

  def format_expression(expression : Stealth::SqlExpression) : Tuple(String, Array(Stealth::BaseArgumentExpression))
    visitor = Stealth::PGFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
