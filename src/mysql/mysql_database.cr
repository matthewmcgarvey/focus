class Stealth::MySqlDatabase < Stealth::Database
  def self.connect(url : String) : MySqlDatabase
    new(raw_db: DB::Database.new(MySql::Driver.new, URI.parse(url)))
  end

  def self.connect(db : DB::Database) : MySqlDatabase
    new(raw_db: db)
  end

  def format_expression(expression : Stealth::SqlExpression) : Tuple(String, Array(Stealth::BaseArgumentExpression))
    visitor = Stealth::MySqlFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
