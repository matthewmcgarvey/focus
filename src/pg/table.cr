class Focus::PG::Table < Focus::Table
  getter dialect : Focus::Dialect = Focus::PG::Dialect.new

  def insert(*columns : Focus::Column) : Focus::PG::InsertStatement
    column_names = columns.map { |column| Focus::ColumnToken.new(column.as(Focus::Column).column_name) }
    expr = Focus::InsertClause.new(self, column_names.to_a)
    Focus::PG::InsertStatement.new(expr)
  end

  def update : Focus::PG::UpdateStatement
    update_clause = Focus::UpdateClause.new(self)
    Focus::PG::UpdateStatement.new(update_clause)
  end

  def delete : Focus::PG::DeleteStatement
    delete_clause = Focus::DeleteClause.new(self)
    Focus::PG::DeleteStatement.new(delete_clause)
  end
end
