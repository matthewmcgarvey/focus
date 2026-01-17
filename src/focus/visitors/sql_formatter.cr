class Focus::SqlFormatter < Focus::SqlVisitor
  WHITESPACE_BYTE = 32_u8

  enum StatementType
    SELECT_STMT_TYPE
    INSERT_STMT_TYPE
    UPDATE_STMT_TYPE
    DELETE_STMT_TYPE
    SET_STMT_TYPE
    LOCK_STMT_TYPE
    UNLOCK_STMT_TYPE
    WITH_STMT_TYPE
  end

  private property statement_type : StatementType?
  private getter sql_string_builder = String::Builder.new
  getter parameters = [] of DB::Any

  def visit_statement(statement : Focus::WithStatement) : Nil
    self.statement_type = statement.statement_type
    write "WITH "
    visit_list statement.ctes
    statement.primary_statement.try(&.accept(self))
  end

  def visit_statement(statement : Focus::Statement) : Nil
    self.statement_type = statement.statement_type
    statement.ordered_clauses.each(&.accept(self))
  end

  def visit_clause(clause : Focus::SelectClause) : Nil
    write "SELECT "
    write "DISTINCT " if clause.distinct?
    visit_list(clause.projections)
  end

  def visit_clause(clause : Focus::FromClause) : Nil
    write "FROM "
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::WhereClause) : Nil
    write "WHERE "
    clause.expression.accept(self)
  end

  def visit_clause(clause : Focus::OrderByListClause) : Nil
    write "ORDER BY "
    visit_list clause.order_bys
  end

  def visit_clause(clause : Focus::OrderByClause) : Nil
    clause.expression.accept(self)
    case clause.order_type
    when Focus::OrderByClause::OrderType::ASCENDING
      write "ASC "
    when Focus::OrderByClause::OrderType::DESCENDING
      write "DESC "
    end
    clause.is_nulls_first.try do |nulls_first|
      write "NULLS #{nulls_first ? "FIRST" : "LAST"} "
    end
  end

  def visit_clause(clause : Focus::LimitClause) : Nil
    write "LIMIT "
    write_placeholder
    parameters << clause.limit
  end

  def visit_clause(clause : Focus::OffsetClause) : Nil
    write "OFFSET "
    write_placeholder
    parameters << clause.offset
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

  def visit_clause(clause : Focus::ValuesClause::Row) : Nil
    wrap_in_parens { visit_list(clause.values) }
  end

  def visit_clause(clause : Focus::QueryClause) : Nil
    clause.query.accept(self)
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

  def visit_clause(clause : Focus::SetClause::Column) : Nil
    clause.column.accept(self)
    write "= "
    if clause.value.is_a?(Focus::Statement)
      wrap_in_parens { clause.value.accept(self) }
    else
      clause.value.accept(self)
    end
  end

  def visit_clause(clause : Focus::DeleteClause) : Nil
    write "DELETE FROM "
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::Clause) : Nil
    raise "shouldn't get here. implement #{clause.class} handling"
  end

  def visit_expression(expression : Focus::AliasedExpression) : Nil
    expression.inner.accept(self)
    write "AS "
    write_identifier(expression.alias)
    write " "
  end

  def visit_expression(expression : Focus::BetweenOperatorExpression) : Nil
    expression.expression.accept(self)
    write "NOT " if expression.negated
    write "BETWEEN "
    expression.min.accept(self)
    write "AND "
    expression.max.accept(self)
  end

  def visit_expression(expression : Focus::BoolExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::BinaryExpression) : Nil
    expression.left.accept(self)
    write "#{expression.operator} "
    expression.right.accept(self)
  end

  def visit_expression(expression : Focus::IntExpression(T)) : Nil forall T
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::FloatExpression(T)) : Nil forall T
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::StringExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::TimeExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::WildcardExpression) : Nil
    if table_name = expression.table_name
      write_identifier(table_name)
      write "."
    end
    write "* "
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

  def visit_expression(expression : Focus::FunctionExpression) : Nil
    if !expression.name.blank?
      write expression.name
    end
    wrap_in_parens { visit_list(expression.parameters) }
  end

  def visit_expression(expression : Focus::CastExpression) : Nil
    write "CAST("
    expression.expression.accept(self)
    write "AS "
    write expression.cast_type.not_nil!
    write ") "
  end

  def visit_expression(expression : Focus::ValueExpression) : Nil
    write_placeholder
    parameters << expression.value
  end

  def visit_expression(expression : Focus::PostfixOperatorExpression)
    expression.expression.accept(self)
    write "#{expression.operator} "
  end

  def visit_expression(expression : Focus::Expression) : Nil
    raise "shouldn't get here. implement visit_expression for #{expression.class}"
  end

  def visit_literal(literal : Focus::Parameter) : Nil
    write_placeholder
    parameters << literal.value
  end

  def visit_column(column : Focus::Column) : Nil
    if subquery = column.subquery
      write_identifier(subquery.alias)
      write "."
    elsif table_name = column.table_name
      write_identifier(table_name)
      write "."
    end
    write_identifier(column.column_name)
    write " "
  end

  def visit_table(table : Focus::CommonTableExpression) : Nil
    if statement_type == StatementType::WITH_STMT_TYPE
      write_identifier table.alias
      write " AS "
      wrap_in_parens { table.statement.accept(self) }
    else
      write_identifier table.alias
      write " "
    end
  end

  def visit_table(table : Focus::SelectTable) : Nil
    wrap_in_parens { table.statement.accept(self) }
    write_identifier table.alias
    write " "
  end

  def visit_table(table : Focus::JoinTable) : Nil
    table.lhs.accept(self)

    case table.join_type
    when Focus::JoinTable::JoinType::INNER
      write "INNER JOIN "
    when Focus::JoinTable::JoinType::LEFT
      write "LEFT JOIN "
    when Focus::JoinTable::JoinType::RIGHT
      write "RIGHT JOIN "
    when Focus::JoinTable::JoinType::CROSS
      write "CROSS JOIN "
    end

    table.rhs.accept(self)
    if condition = table.condition
      write "ON "
      condition.accept(self)
    end
  end

  def visit_table(table : Focus::Table) : Nil
    write_identifier(table.table_name)
    write " "
    if table_alias = table.table_alias
      write_identifier(table_alias)
      write " "
    end
  end

  def visit_table(table : Focus::SerializableTable) : Nil
    raise "shouldn't get here. implement #{table.class} handling"
  end

  def visit_token(token : Focus::ColumnToken) : Nil
    write_identifier(token.column)
    write " "
  end

  def visit_token(token : Focus::Token) : Nil
    raise "should get here. implement #{token.class} handling"
  end

  def to_sql : String
    sql_string_builder.to_s.strip
  end

  protected def visit_list(expressions : Array)
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

  protected def write_placeholder
    write "? "
  end

  protected def write_identifier(name : String)
    if should_quote?(name)
      write quoted(name)
    else
      write name
    end
  end

  protected def write(str : String)
    sql_string_builder << str
  end

  protected def should_quote?(str : String)
    str.each_char_with_index do |char, idx|
      next if (char.number? && idx > 0) || char == '_'
      return true if !char.letter? || char.uppercase?
    end
    false
  end

  protected def quoted(str : String)
    %["#{str}"]
  end

  protected def wrap_in_parens(&)
    write "("
    yield
    remove_last_blank
    write ") "
  end
end
