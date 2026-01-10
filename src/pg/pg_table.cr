class Focus::PGTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::PGDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::PG::SelectStatement
    Focus::PG.select(*fields).from(self)
  end

  def select : Focus::PG::SelectStatement
    Focus::PG.select.from(self)
  end

  def insert(*columns : Focus::Column) : Focus::PG::InsertStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    column_names = columns.map { |column| Focus::ColumnToken.new(column.column_name) }
    expr = Focus::InsertClause.new(table_ref, column_names.to_a)
    Focus::PG::InsertStatement.new(expr)
  end

  def update : Focus::PG::UpdateStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    update = Focus::UpdateClause.new(table_ref)
    Focus::PG::UpdateStatement.new(update: update)
  end

  def delete : Focus::PG::DeleteStatement
    table_ref = Focus::TableReferenceExpression.new(table_name, table_alias)
    delete = Focus::DeleteClause.new(table_ref)
    Focus::PG::DeleteStatement.new(delete)
  end
end
