class Focus::SQLiteTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLiteDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::SQLite::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    select_clause = Focus::SelectClause.new(projections)
    Focus::SQLite::SelectStatement.new(select_clause).from(self)
  end

  def select : Focus::SQLite::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select(projection)
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
