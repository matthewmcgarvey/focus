class Focus::SqlFormatter < Focus::SqlVisitor
  WHITESPACE_BYTE = 32_u8

  private getter sql_string_builder = String::Builder.new
  getter parameters = [] of Focus::Parameter

  # def visit(expression : Focus::SelectExpression)
  #   write "select "
  #   write "distinct " if expression.is_distinct
  #   columns = expression.columns
  #   if columns.nil? || columns.empty?
  #     write "* "
  #   else
  #     visit_list(columns)
  #   end
  #   if from = expression.from
  #     write "from "
  #     visit_query_source(from)
  #   end
  #   if where = expression.where
  #     write "where "
  #     where.accept(self)
  #   end
  #   group_by = expression.group_by
  #   if group_by && !group_by.empty?
  #     write "group by "
  #     visit_list group_by
  #   end
  #   if having = expression.having
  #     write "having "
  #     having.accept(self)
  #   end
  #   order_by = expression.order_by
  #   if order_by && !order_by.empty?
  #     write "order by "
  #     visit_list order_by
  #   end
  #   if limit = expression.limit
  #     write "limit #{limit} "
  #   end
  #   if offset = expression.offset
  #     write "offset #{offset} "
  #   end
  # end

  # def visit(expression : Focus::BaseColumnExpression)
  #   if table_name = expression.table_name
  #     write "#{quoted(table_name)}."
  #   end
  #   write "#{quoted(expression.name)} "
  # end

  # def visit(expression : Focus::TableExpression)
  #   if catalog = expression.catalog.presence
  #     write "#{quoted(catalog)}."
  #   end
  #   if schema = expression.schema.presence
  #     write "#{quoted(schema)}."
  #   end
  #   write "#{quoted(expression.name)} "

  #   if table_alias = expression.table_alias.presence
  #     write "#{quoted(table_alias)} "
  #   end

  #   joins = expression.joins
  #   if joins && !joins.empty?
  #     joins.each do |join|
  #       join.accept(self)
  #     end
  #   end
  # end

  # def visit(expression : Focus::BinaryExpression)
  #   if expression.left.wrap_in_parens?
  #     wrap_in_parens do
  #       expression.left.accept(self)
  #     end
  #   else
  #     expression.left.accept(self)
  #   end

  #   write "#{expression.operator} "

  #   if expression.right.wrap_in_parens?
  #     wrap_in_parens do
  #       expression.right.accept(self)
  #     end
  #   else
  #     expression.right.accept(self)
  #   end
  # end

  # def visit(expression : Focus::UnaryExpression(_))
  #   case expression.type
  #   when UnaryExpressionType::IS_NULL, UnaryExpressionType::IS_NOT_NULL
  #     if expression.operand.wrap_in_parens?
  #       wrap_in_parens do
  #         expression.operand.accept(self)
  #       end
  #     else
  #       expression.operand.accept(self)
  #     end
  #     write "#{expression.operator} "
  #   else
  #     write "#{expression.operator} "

  #     if expression.operand.wrap_in_parens?
  #       wrap_in_parens do
  #         expression.operand.accept(self)
  #       end
  #     else
  #       expression.operand.accept(self)
  #     end
  #   end
  # end

  # def visit(expression : Focus::ArgumentExpression)
  #   write "? "
  #   parameters << expression
  # end

  # def visit(expression : Focus::BetweenExpression(_))
  #   expression.expression.accept(self)

  #   if expression.not_between
  #     write "not between "
  #   else
  #     write "between "
  #   end

  #   expression.lower.accept(self)
  #   write "and "
  #   expression.upper.accept(self)
  # end

  # def visit(expression : Focus::ColumnDeclaringExpression(_))
  #   expression.expression.accept(self)
  #   declared_name = expression.declared_name.presence
  #   column_expression = expression.expression.as?(Focus::ColumnExpression)
  #   if declared_name && (column_expression.nil? || column_expression.name != declared_name)
  #     write "as #{quoted(declared_name)} "
  #   end
  # end

  # def visit(expression : Focus::AggregateExpression(_))
  #   write "#{expression.method}("
  #   if expression.is_distinct
  #     write "distinct "
  #   end

  #   if arg = expression.argument
  #     arg.accept(self)
  #   else
  #     write "*"
  #   end

  #   remove_last_blank
  #   write ") "
  # end

  # def visit(expression : Focus::InsertExpression)
  #   write "insert into "
  #   expression.table.as_expression.accept(self)
  #   write_insert_column_names(expression.columns.map(&.as_expression))
  #   if arguments = expression.arguments
  #     write "values "
  #     write_insert_values(arguments)
  #   elsif query = expression.query
  #     visit query
  #   end
  #   returning = expression.returning
  #   if returning && !returning.empty?
  #     write "returning "
  #     visit_list(returning.map(&.as_expression))
  #   end
  # end

  # def visit(expression : Focus::UpdateExpression)
  #   write "update "
  #   expression.table.as_expression.accept(self)
  #   write "set "
  #   if assignments = expression.assignments
  #     visit_column_assignments(assignments)
  #   end
  #   if where = expression.where
  #     write "where "
  #     where.accept(self)
  #   end
  #   if returning = expression.returning
  #     write "returning "
  #     visit_list(returning.map(&.as_expression))
  #   end
  # end

  # def visit(expression : Focus::InListExpression)
  #   expression.left.accept(self)

  #   if expression.not_in_list
  #     write "not in "
  #   else
  #     write "in "
  #   end

  #   if query = expression.query
  #     visit_query_source(query)
  #   end
  #   if values = expression.values
  #     write "("
  #     visit_list(values)
  #     remove_last_blank
  #     write ") "
  #   end
  # end

  # def visit(expression : Focus::JoinExpression)
  #   write "#{expression.join_type} "
  #   visit_query_source(expression.join_table.as_expression)

  #   if condition = expression.condition
  #     write "on "
  #     condition.accept(self)
  #   end
  # end

  # def visit(expression : Focus::OrderByExpression)
  #   expression.expression.accept(self)
  #   write "#{expression.order} "
  # end

  # def visit(expression : Focus::DeleteExpression)
  #   write "delete from "
  #   expression.table.as_expression.accept(self)

  #   if where = expression.where
  #     write "where "
  #     where.accept(self)
  #   end

  #   returning = expression.returning
  #   if returning && !returning.empty?
  #     write "returning "
  #     visit_list(returning.map(&.as_expression))
  #   end

  #   order_by = expression.order_by
  #   if order_by && !order_by.empty?
  #     write "order by "
  #     visit_list order_by
  #   end
  #   if limit = expression.limit
  #     write "limit #{limit} "
  #   end
  #   if offset = expression.offset
  #     write "offset #{offset} "
  #   end
  # end

  # def visit(expression : ExistsExpression)
  #   if expression.not_exists
  #     write "not exists"
  #   else
  #     write "exists "
  #   end

  #   visit_query_source(expression.query)
  # end

  # # TODO: figure out a good way to handle formatters not
  # # providing all expected overloads
  # def visit(expression : Focus::SqlExpression)
  #   raise "No visit method found for #{expression.class.name}"
  # end

  # protected def visit_column_assignments(assignments : Array(BaseColumnAssignmentExpression))
  #   assignments.each_with_index do |assignment, idx|
  #     if idx > 0
  #       remove_last_blank
  #       write ", "
  #     end

  #     write "#{quoted(assignment.column.name)} = "
  #     if expr = assignment.expression
  #       expr.accept(self)
  #     elsif query = assignment.query
  #       wrap_in_parens { query.accept(self) }
  #     end
  #   end
  # end

  # protected def visit_query_source(expression : QuerySourceExpression)
  #   case expression
  #   when TableExpression, JoinExpression
  #     expression.accept(self)
  #   when QueryExpression
  #     write "("
  #     expression.accept(self)
  #     remove_last_blank
  #     write ") "
  #     expression.table_alias.try { |table_alias| write "#{quoted(table_alias)} " }
  #   end
  # end

  # protected def write_insert_column_names(columns : Array(BaseColumnExpression))
  #   write "("
  #   columns.each_with_index do |column, idx|
  #     write ", " if idx > 0
  #     write quoted(column.name)
  #   end
  #   write ") "
  # end

  # protected def write_insert_values(arguments : Array(Array(BaseScalarExpression)))
  #   row_count = arguments.size
  #   arguments.each_with_index do |row, idx|
  #     write "("
  #     visit_list(row)
  #     remove_last_blank
  #     write ")"
  #     if idx + 1 < row_count
  #       write ","
  #     end
  #     write " "
  #   end
  # end

  def visit_statement(statement : Focus::SelectStatement) : Nil
    statement.select_clause.accept(self)
    statement.from_clause.try(&.accept(self))
    statement.where_clause.try(&.accept(self))
    statement.group_by_clause.try(&.accept(self))
    statement.having_clause.try(&.accept(self))
    statement.order_by_clause.try(&.accept(self))
    statement.limit_clause.try(&.accept(self))
    statement.offset_clause.try(&.accept(self))
  end

  def visit_statement(statement : Focus::InsertStatement) : Nil
    statement.insert_clause.accept(self)
    statement.values_clause.try(&.accept(self))
    statement.query.try(&.accept(self))
    statement.returning.try(&.accept(self))
  end

  def visit_statement(statement : Focus::Statement) : Nil
    raise "shouldn't get here. implement #{statement.class} handling"
  end

  def visit_clause(clause : Focus::SelectClause) : Nil
    write "SELECT "
    write "DISTINCT " if clause.distinct?
    visit_list(clause.projections)
  end

  def visit_clause(clause : Focus::FromClause) : Nil
    write "FROM "
    clause.table_source.accept(self)
  end

  def visit_clause(clause : Focus::WhereClause) : Nil
    write "WHERE "
    clause.expression.accept(self)
  end

  def visit_clause(clause : Focus::OrderByClause) : Nil
    write "ORDER BY "
    visit_list clause.order_bys
  end

  def visit_clause(clause : Focus::LimitClause) : Nil
    write "LIMIT #{clause.limit} "
  end

  def visit_clause(clause : Focus::OffsetClause) : Nil
    write "OFFSET #{clause.offset} "
  end

  def visit_clause(clause : Focus::GroupByClause) : Nil
    write "GROUP BY "
    visit_list clause.group_bys
  end

  def visit_clause(clause : Focus::HavingClause) : Nil
    write "HAVING "
    clause.expression.accept(self)
  end

  def visit_clause(clause : Focus::InsertClause) : Nil
    write "INSERT INTO "
    clause.table.accept(self)
    wrap_in_parens { visit_list(clause.columns) }
  end

  def visit_clause(clause : Focus::ValuesClause) : Nil
    write "VALUES "
    visit_list clause.rows
  end

  def visit_clause(clause : Focus::ReturningClause) : Nil
    write "RETURNING "
    visit_list clause.columns
  end

  def visit_clause(clause : Focus::Clause) : Nil
    raise "shouldn't get here. implement #{clause.class} handling"
  end

  def visit_expression(expression : Focus::ProjectionExpression) : Nil
    expression.inner.accept(self)
    if proj_alias = expression.projection_alias
      write "AS #{quoted(proj_alias)} "
    end
  end

  def visit_expression(expression : Focus::Column) : Nil
    if table_name = expression.table_name
      write "#{quoted(table_name)}."
    end
    write "#{quoted(expression.name)} "
  end

  def visit_expression(expression : Focus::TableReferenceExpression) : Nil
    write "#{quoted(expression.table_name)} "
    if table_alias = expression.table_alias
      write "#{quoted(table_alias)} "
    end
  end

  def visit_expression(expression : Focus::BoolExpression) : Nil
    expression.inner.accept(self)
  end

  def visit_expression(expression : Focus::BinaryExpression) : Nil
    expression.left.accept(self)
    write "#{expression.operator} "
    expression.right.accept(self)
  end

  def visit_expression(expression : Focus::Int32Expression) : Nil
    write "? "
    parameters << expression
  end

  def visit_expression(expression : Focus::WildcardExpression) : Nil
    if table_name = expression.table_name
      write "#{quoted(table_name)}."
    end
    write "* "
  end

  def visit_expression(expression : Focus::OrderByExpression) : Nil
    expression.inner.accept(self)
    case expression.order_type
    when Focus::OrderByExpression::OrderType::ASCENDING
      write "ASC "
    when Focus::OrderByExpression::OrderType::DESCENDING
      write "DESC "
    end
  end

  def visit_expression(expression : Focus::AggregateExpression) : Nil
    method = case expression.type
    when Focus::AggregateExpression::AggregateType::MIN
      "MIN"
    when Focus::AggregateExpression::AggregateType::MAX
      "MAX"
    when Focus::AggregateExpression::AggregateType::AVG
      "AVG"
    when Focus::AggregateExpression::AggregateType::SUM
      "SUM"
    when Focus::AggregateExpression::AggregateType::COUNT
      "COUNT"
    else
      raise "unexpected aggregate expression method '#{expression.type}'"
    end
    write method
    wrap_in_parens { expression.argument.accept(self) }
  end

  def visit_expression(expression : Focus::JoinExpression) : Nil
    expression.left.accept(self)

    case expression.join_type
    when Focus::JoinExpression::JoinType::INNER
      write "INNER JOIN "
    when Focus::JoinExpression::JoinType::LEFT
      write "LEFT JOIN "
    when Focus::JoinExpression::JoinType::RIGHT
      write "RIGHT JOIN "
    when Focus::JoinExpression::JoinType::CROSS
      write "CROSS JOIN "
    end

    expression.right.accept(self)
    if condition = expression.condition
      write "ON "
      condition.accept(self)
    end
  end

  def visit_expression(expression : Focus::FunctionExpression) : Nil
    if !expression.name.blank?
      write "#{expression.name} "
    end
    wrap_in_parens { visit_list(expression.parameters) }
  end

  def visit_expression(expression : Focus::SubqueryExpression) : Nil
    wrap_in_parens { expression.subquery.accept(self) }
    if subquery_alias = expression.subquery_alias
      write "#{quoted(subquery_alias)} "
    end
  end

  def visit_expression(expression : Focus::RowConstructorExpression) : Nil
    wrap_in_parens { visit_list(expression.values) }
  end

  def visit_expression(expression : Focus::ValueExpression) : Nil
    write "? "
    parameters << expression
  end

  def visit_expression(expression : Focus::Expression) : Nil
    raise "shouldn't get here. implement #{expression.class} handling"
  end

  def visit_token(token : Focus::ColumnToken) : Nil
     write "#{quoted(token.column)} "
  end

  def visit_token(token : Focus::Token) : Nil
    raise "should get here. implement #{token.class} handling"
  end

  def to_sql : String
    sql_string_builder.to_s.strip
  end

  protected def visit_list(expressions : Array(Focus::Expression))
    expressions.each_with_index do |expression, idx|
      if idx > 0
        remove_last_blank
        write ", "
      end

      expression.accept(self)
    end
  end

  protected def remove_last_blank
    sql_string_builder.chomp!(WHITESPACE_BYTE)
  end

  protected def write(str : String)
    sql_string_builder << str
  end

  protected def quoted(str : String)
    str
  end

  protected def wrap_in_parens(&)
    write "("
    yield
    remove_last_blank
    write ") "
  end
end
