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

  # def insert(table : Focus::Table, *columns : Focus::BaseColumn) : Focus::InsertStatement
  #   column_arr = columns.select(Focus::BaseColumn)
  #   insert_expression = Focus::InsertExpression.new(table, column_arr)
  #   Focus::InsertStatement.new(expression: insert_expression)
  # end

  # def update(table : Focus::Table) : Focus::UpdateStatement
  #   update_expression = Focus::UpdateExpression.new(table)
  #   Focus::UpdateStatement.new(expression: update_expression)
  # end

  # def delete(table : Focus::Table) : Focus::DeleteStatement
  #   delete_expression = Focus::DeleteExpression.new(table)
  #   Focus::DeleteStatement.new(expression: delete_expression)
  # end
end
