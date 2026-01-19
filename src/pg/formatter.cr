class Focus::PG::Formatter < Focus::SqlFormatter
  property argument_counter = 1

  protected def write_placeholder
    write "$#{argument_counter} "
    self.argument_counter += 1
  end

  # def visit(expression : TableExpression)
  #   if catalog = expression.catalog.presence
  #     write "#{quoted(catalog)}."
  #   end
  #   if schema = expression.schema.presence
  #     write "#{quoted(schema)}."
  #   end
  #   write "#{quoted(expression.name)} "

  #   if table_alias = expression.table_alias.presence
  #     write "as #{quoted(table_alias)} "
  #   end
  # end

  # def visit(expression : Focus::ArgumentExpression)
  #   write "$#{argument_counter} "
  #   parameters << expression
  #   self.argument_counter += 1
  # end

  # def visit(expression : Focus::ILikeExpression)
  #   if expression.left.wrap_in_parens?
  #     wrap_in_parens do
  #       expression.left.accept(self)
  #     end
  #   else
  #     expression.left.accept(self)
  #   end
  #   write "ilike "
  #   if expression.right.wrap_in_parens?
  #     wrap_in_parens do
  #       expression.right.accept(self)
  #     end
  #   else
  #     expression.right.accept(self)
  #   end
  # end

  # def visit(expression : Focus::InsertOrUpdateExpression)
  #   write "insert into "
  #   expression.table.accept(self)
  #   write_insert_column_names(expression.assignments.map(&.column.as(BaseColumnExpression)))
  #   write "values "
  #   write_insert_values(expression.assignments)

  #   if expression.conflict_columns.any?
  #     write "on conflict "
  #     write_insert_column_names(expression.conflict_columns)

  #     if expression.update_assignments.any?
  #       write "do update set "
  #       visit_column_assignments(expression.update_assignments)
  #     else
  #       write "do nothing "
  #     end
  #   end

  #   if expression.returning_columns.any?
  #     write "returning "

  #     expression.returning_columns.each_with_index do |returning_column, idx|
  #       write ", " if idx > 0
  #       write quoted(returning_column.name)
  #     end
  #   end
  # end
end
