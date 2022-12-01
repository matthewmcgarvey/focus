abstract class Focus::Database
  def self.connect(url : String) : Database
    new(raw_db: DB.open(url))
  end

  def self.connect(db : DB::Database) : Database
    new(raw_db: db)
  end

  private getter raw_db : DB::Database
  private getter transaction_manager : Focus::TransactionManager

  def initialize(@raw_db : DB::Database)
    @transaction_manager = Focus::TransactionManager.new(raw_db)
  end

  def setup_connection(&block : DB::Connection -> _)
    raw_db.setup_connection do |conn|
      block.call conn
    end
  end

  def from(table : Focus::Table) : Focus::QuerySource
    Focus::QuerySource.new(self, table, table.as_expression)
  end

  def insert(table : Focus::Table) : Int64
    builder = Focus::AssignmentsBuilder.new
    with builder yield
    expression = InsertExpression.new(table.as_expression, builder.assignments)
    execute_update(expression)
  end

  def insert_returning_generated_key(table : Focus::Table, column : Focus::Column(T)) : T forall T
    builder = Focus::AssignmentsBuilder.new
    with builder yield
    expression = InsertExpression.new(table.as_expression, builder.assignments)
    result_set = execute_insert_and_return_generated_key(expression, column)
    rows = [] of Focus::CachedRow
    begin
      result_set.each do
        rows << Focus::CachedRow.build(result_set)
      end
    ensure
      result_set.close
    end
    rows
    if row = rows.first?
      row.get(0, type: T)
    else
      raise "Expected a key to be returned by the database"
    end
  end

  def update(table : Focus::Table) : Int64
    builder = Focus::UpdateStatementBuilder.new
    with builder yield
    expression = Focus::UpdateExpression.new(
      table.as_expression,
      builder.assignments,
      builder.where.try(&.as_expression)
    )
    execute_update(expression)
  end

  def delete(table : Focus::Table, where : ColumnDeclaring(Bool)) : Int64
    expression = DeleteExpression.new(table.as_expression, where.as_expression)
    execute_update(expression)
  end

  def delete_all(table : Focus::Table) : Int64
    expression = DeleteExpression.new(table.as_expression, where: nil)
    execute_update(expression)
  end

  def close : Nil
    raw_db.close
  end

  def execute_query(expression : Focus::SqlExpression) : DB::ResultSet
    sql, args = format_expression(expression)
    with_connection do |conn|
      conn.query(sql, args: args.map(&.value))
    end
  end

  def execute_update(expression : Focus::SqlExpression) : Int64
    sql, args = format_expression(expression)
    with_connection do |conn|
      conn.exec(sql, args: args.map(&.value)).rows_affected
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

  abstract def format_expression(expression : Focus::SqlExpression) : Tuple(String, Array(Focus::BaseArgumentExpression))
  abstract def execute_insert_and_return_generated_key(expression : Focus::InsertExpression, column : Focus::BaseColumn) : DB::ResultSet
end
