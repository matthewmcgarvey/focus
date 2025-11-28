class Focus::MySqlDatabase < Focus::Database
  def self.connect(url : String) : MySqlDatabase
    new(raw_db: DB.open(url))
  end

  def self.connect(db : DB::Database) : MySqlDatabase
    new(raw_db: db)
  end

  def format_expression(expression : Focus::SqlExpression) : Tuple(String, Array(Focus::BaseArgumentExpression))
    visitor = Focus::MySqlFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  def execute_insert_and_return_generated_key(expression : Focus::InsertExpression, column : Focus::BaseColumn) : DB::ResultSet
    with_connection do |conn|
      sql, args = format_expression(expression)
      conn.exec(sql, args: args.map(&.value))
      conn.query("select last_insert_id()")
    end
  end
end
