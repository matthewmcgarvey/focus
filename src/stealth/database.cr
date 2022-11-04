class Stealth::Database
  def self.connect(url : String) : Database
    new(raw_db: DB.open(url))
  end

  def self.connect(db : DB::Database) : Database
    new(raw_db: db)
  end

  private getter raw_db : DB::Database
  private getter transaction_manager : Stealth::TransactionManager

  def initialize(@raw_db : DB::Database)
    @transaction_manager = Stealth::TransactionManager.new(raw_db)
  end

  def from(table : Stealth::Table) : Stealth::QuerySource
    Stealth::QuerySource.new(self, table, table.as_expression)
  end

  def close : Nil
    raw_db.close
  end

  def execute_query(expression : Stealth::SqlExpression) : DB::ResultSet
    sql, args = format_expression(expression)
    with_connection do |conn|
      conn.query(sql, args: args.map(&.value))
    end
  end

  def with_connection(&block : DB::Connection -> T) : T forall T
    transaction_manager.with_connection do |conn|
      yield conn
    end
  end

  def with_transaction(&block : DB::Transaction -> T) : T? forall T
    transaction_manager.with_transaction do |txn|
      yield txn
    end
  end

  def format_expression(expression : Stealth::SqlExpression) : Tuple(String, Array(Stealth::BaseArgumentExpression))
    visitor = Stealth::SqlVisitor.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end
end
