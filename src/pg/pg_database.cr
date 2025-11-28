class Focus::PGDatabase < Focus::Database
  def self.connect(url : String) : PGDatabase
    new(raw_db: DB.open(url))
  end

  def self.connect(db : DB::Database) : PGDatabase
    new(raw_db: db)
  end

  def format_expression(expression : Focus::SqlExpression) : Tuple(String, Array(Focus::BaseArgumentExpression))
    visitor = Focus::PGFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  def execute_insert_and_return_generated_key(expression : Focus::InsertExpression, column : Focus::BaseColumn) : DB::ResultSet
    returning_expression = InsertOrUpdateExpression.new(
      table: expression.table,
      assignments: expression.assignments,
      returning_columns: [column.as_expression] of BaseColumnExpression
    )
    execute_query(returning_expression)
  end
end
