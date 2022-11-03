class Stealth::Database
  def self.connect(url : String) : Database
    new(raw_db: DB.open(url))
  end

  def self.connect(db : DB::Database) : Database
    new(raw_db: db)
  end

  private getter raw_db : DB::Database

  def initialize(@raw_db : DB::Database)
  end

  def from(table : Stealth::Table) : Stealth::QuerySource
    Stealth::QuerySource.new(self, table, table.as_expression)
  end

  def close : Nil
    raw_db.close
  end

  def execute_query(expression : Stealth::SqlExpression) : DB::ResultSet
    raw_db.query(to_sql(expression))
  end

  def with_connection
    raw_db.using_connection do |conn|
      yield conn
    end
  end

  def to_sql(expression : Stealth::SqlExpression) : String
    visitor = Stealth::SqlVisitor.new
    expression.accept(visitor)
    visitor.to_sql
  end
end
