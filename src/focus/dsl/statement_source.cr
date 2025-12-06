module Focus::Dsl::StatementSource
  def select(*fields : Focus::Column | Focus::ProjectionExpression) : Focus::SelectStatement
    projections = fields.map { |field| (field.is_a?(Focus::Column) ? Focus::ProjectionExpression.new(field) : field).as(Focus::ProjectionExpression) }
    select_clause = Focus::SelectClause.new(projections.to_a)
    Focus::SelectStatement.new(select_clause)
    # select_expression = Focus::SelectExpression.new
    # select_expression.columns = columns.map(&.as_declaring_expression).select(Focus::BaseColumnDeclaringExpression) # cuz generics
    # Focus::SelectQuery.new(expression: select_expression)
  end

  def select : Focus::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select(projection)
  end

  def insert(table : Focus::Table, *columns : Focus::Column) : Focus::InsertStatement
    table_ref = Focus::TableReferenceExpression.new(table.table_name, table.label)
    column_names = columns.map { |column| Focus::ColumnToken.new(column.name) }
    expr = Focus::InsertClause.new(table_ref, column_names.to_a)
    Focus::InsertStatement.new(expr)
  end

  def update(table : Focus::Table) : Focus::UpdateStatement
    table_ref = Focus::TableReferenceExpression.new(table.table_name, table.label)
    update = Focus::UpdateClause.new(table_ref)
    Focus::UpdateStatement.new(update: update)
  end

  # def delete(table : Focus::Table) : Focus::DeleteStatement
  #   delete_expression = Focus::DeleteExpression.new(table)
  #   Focus::DeleteStatement.new(expression: delete_expression)
  # end
end
