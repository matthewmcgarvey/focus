class Focus::SqlFormatter < Focus::SqlVisitor
  WHITESPACE_BYTE = 32_u8

  private getter sql_string_builder = String::Builder.new
  getter parameters = [] of Focus::Parameter

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

  def visit_statement(statement : Focus::UpdateStatement) : Nil
    statement.update.accept(self)
    statement.set.try(&.accept(self))
    statement.where.try(&.accept(self))
    statement.returning.try(&.accept(self))
  end

  def visit_statement(statement : Focus::DeleteStatement) : Nil
    statement.delete.accept(self)
    statement.where.try(&.accept(self))
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

  def visit_clause(clause : Focus::UpdateClause) : Nil
    write "UPDATE "
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::SetClause) : Nil
    write "SET "
    visit_list clause.set_columns
  end

  def visit_clause(clause : Focus::DeleteClause) : Nil
    write "DELETE FROM "
    clause.table.accept(self)
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
    write "#{quoted(expression.column_name)} "
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
    expression.is_nulls_first.try do |nulls_first|
      write "NULLS #{nulls_first ? "FIRST" : "LAST"} "
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

  def visit_expression(expression : Focus::SetColumnExpression) : Nil
    expression.column.accept(self)
    write "= "
    if expression.value.is_a?(Focus::SelectStatement)
      wrap_in_parens { expression.value.accept(self) }
    else
      expression.value.accept(self)
    end
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
