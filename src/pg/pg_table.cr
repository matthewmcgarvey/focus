class Focus::PGTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::PGDialect.new

  def insert(*columns : Focus::Column) : Focus::PG::InsertStatement
    column_names = columns.map { |column| Focus::ColumnToken.new(column.column_name) }
    expr = Focus::InsertClause.new(self, column_names.to_a)
    Focus::PG::InsertStatement.new(expr)
  end

  def update : Focus::PG::UpdateStatement
    update = Focus::UpdateClause.new(self)
    Focus::PG::UpdateStatement.new(update: update)
  end

  def delete : Focus::PG::DeleteStatement
    delete = Focus::DeleteClause.new(self)
    Focus::PG::DeleteStatement.new(delete)
  end
end
