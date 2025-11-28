module Focus::Dsl::StatementSource
  def select(*columns : Focus::BaseColumnDeclaring) : Focus::SelectQuery
    self.select(columns.to_a)
  end

  def select(columns : Enumerable(Focus::BaseColumnDeclaring)) : Focus::SelectQuery
    select_expression = Focus::SelectExpression.new
    select_expression.columns = columns.map(&.as_declaring_expression).select(Focus::BaseColumnDeclaringExpression) # cuz generics
    Focus::SelectQuery.new(expression: select_expression)
  end

  def select : Focus::SelectQuery
    select_expression = Focus::SelectExpression.new
    Focus::SelectQuery.new(expression: select_expression)
  end

  def insert(table : Focus::Table, *columns : Focus::BaseColumn) : Focus::InsertStatement
    column_arr = columns.select(Focus::BaseColumn)
    insert_expression = Focus::InsertExpression.new(table, column_arr)
    Focus::InsertStatement.new(expression: insert_expression)
  end

  def update(table : Focus::Table) : Focus::UpdateStatement
    update_expression = Focus::UpdateExpression.new(table)
    Focus::UpdateStatement.new(expression: update_expression)
  end

  def delete(table : Focus::Table) : Focus::DeleteStatement
    delete_expression = Focus::DeleteExpression.new(table)
    Focus::DeleteStatement.new(expression: delete_expression)
  end
end
