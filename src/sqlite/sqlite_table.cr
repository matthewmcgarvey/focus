class Focus::SQLiteTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLiteDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression | Array(Focus::Column)) : Focus::SQLite::SelectStatement
    Focus::SQLite.select(*fields).from(self)
  end

  def select : Focus::SQLite::SelectStatement
    Focus::SQLite.select.from(self)
  end

  def insert(*columns : Focus::Column) : Focus::SQLite::InsertStatement
    column_names = columns.map { |column| Focus::ColumnToken.new(column.column_name) }
    expr = Focus::InsertClause.new(self, column_names.to_a)
    Focus::SQLite::InsertStatement.new(expr)
  end

  def update : Focus::SQLite::UpdateStatement
    update = Focus::UpdateClause.new(self)
    Focus::SQLite::UpdateStatement.new(update: update)
  end

  def delete : Focus::SQLite::DeleteStatement
    delete = Focus::DeleteClause.new(self)
    Focus::SQLite::DeleteStatement.new(delete)
  end
end
