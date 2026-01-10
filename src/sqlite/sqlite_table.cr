class Focus::SQLiteTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLiteDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression | Array(Focus::Column)) : Focus::SQLite::SelectStatement
    Focus::SQLite.select(*fields).from(self)
  end

  def select : Focus::SQLite::SelectStatement
    Focus::SQLite.select.from(self)
  end

  def insert(*columns : Focus::Column) : Focus::SQLite::InsertStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    column_names = columns.map { |column| Focus::ColumnToken.new(column.column_name) }
    expr = Focus::InsertClause.new(table_ref, column_names.to_a)
    Focus::SQLite::InsertStatement.new(expr)
  end

  def update : Focus::SQLite::UpdateStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    update = Focus::UpdateClause.new(table_ref)
    Focus::SQLite::UpdateStatement.new(update: update)
  end

  def delete : Focus::SQLite::DeleteStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    delete = Focus::DeleteClause.new(table_ref)
    Focus::SQLite::DeleteStatement.new(delete)
  end
end
