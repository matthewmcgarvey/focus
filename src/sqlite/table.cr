class Focus::SQLite::Table < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLite::Dialect.new

  def insert(*columns : Focus::Column) : Focus::SQLite::InsertStatement
    column_names = columns.map { |column| Focus::ColumnToken.new(column.as(Focus::Column).column_name) }
    expr = Focus::InsertClause.new(self, column_names.to_a)
    Focus::SQLite::InsertStatement.new(expr)
  end

  def update : Focus::SQLite::UpdateStatement
    update_clause = Focus::UpdateClause.new(self)
    Focus::SQLite::UpdateStatement.new(update_clause)
  end

  def delete : Focus::SQLite::DeleteStatement
    delete_clause = Focus::DeleteClause.new(self)
    Focus::SQLite::DeleteStatement.new(delete_clause)
  end
end
