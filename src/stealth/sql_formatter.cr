class Stealth::SqlFormatter < Stealth::SqlVisitor
  WHITESPACE_BYTE = 32_u8

  private getter sql_string_builder = String::Builder.new
  getter parameters = [] of Stealth::BaseArgumentExpression

  def visit(expression : Stealth::SelectExpression)
    write "SELECT "
    visit_list(expression.columns)
    write "FROM "
    visit_query_source(expression.from)
    if where = expression.where
      write "WHERE "
      where.accept(self)
    end
  end

  def visit(expression : Stealth::BaseColumnExpression)
    if table = expression.table
      if table_alias = table.table_alias.presence
        write "#{quoted(table_alias)}."
      else
        if catalog = table.catalog.presence
          write "#{quoted(catalog)}."
        end
        if schema = table.schema.presence
          write "#{quoted(schema)}."
        end
        write "#{quoted(table.name)}."
      end
    end
    write "#{quoted(expression.name)} "
  end

  def visit(expression : Stealth::TableExpression)
    if catalog = expression.catalog.presence
      write "#{quoted(catalog)}."
    end
    if schema = expression.schema.presence
      write "#{quoted(schema)}."
    end
    write "#{quoted(expression.name)} "

    if table_alias = expression.table_alias.presence
      write "#{quoted(table_alias)} "
    end
  end

  def visit(expression : Stealth::BinaryExpression(_))
    if expression.left.wrap_in_parens?
      wrap_in_parens do
        expression.left.accept(self)
      end
    else
      expression.left.accept(self)
    end

    write "#{expression.operator} "

    if expression.right.wrap_in_parens?
      wrap_in_parens do
        expression.right.accept(self)
      end
    else
      expression.right.accept(self)
    end
  end

  def visit(expression : Stealth::UnaryExpression(_))
    case expression.type
    when UnaryExpressionType::IS_NULL, UnaryExpressionType::IS_NOT_NULL
      if expression.operand.wrap_in_parens?
        wrap_in_parens do
          expression.operand.accept(self)
        end
      else
        expression.operand.accept(self)
      end
      write "#{expression.operator} "
    else
      write "#{expression.operator} "

      if expression.operand.wrap_in_parens?
        wrap_in_parens do
          expression.operand.accept(self)
        end
      else
        expression.operand.accept(self)
      end
    end
  end

  def visit(expression : Stealth::ArgumentExpression)
    write "? "
    parameters << expression
  end

  def visit(expression : Stealth::BetweenExpression(_))
    expression.expression.accept(self)

    if expression.not_between
      write "not between "
    else
      write "between "
    end

    expression.lower.accept(self)
    write "and "
    expression.upper.accept(self)
  end

  def visit(expression : Stealth::ColumnDeclaringExpression(_))
    expression.expression.accept(self)
    declared_name = expression.declared_name.presence
    column_expression = expression.expression.as?(Stealth::ColumnExpression)
    if declared_name && (column_expression.nil? || column_expression.name != declared_name)
      write "as #{quoted(declared_name)} "
    end
  end

  def visit(expression : Stealth::AggregateExpression(_))
    write "#{expression.method}("
    if expression.is_distinct
      write "distinct "
    end

    if arg = expression.argument
      arg.accept(self)
    else
      write "*"
    end

    remove_last_blank
    write ") "
  end

  def visit(expression : Stealth::InsertExpression)
    write "insert into "
    expression.table.accept(self)
    write_insert_column_names(expression.assignments.map(&.column))
    write "values "
    write_insert_values(expression.assignments)
  end

  def visit(expression : Stealth::UpdateExpression)
    write "update "
    expression.table.accept(self)
    write "set "
    visit_column_assignments(expression.assignments)
    if where = expression.where
      write "where "
      where.accept(self)
    end
  end

  def visit(expression : Stealth::InListExpression)
    expression.left.accept(self)

    if expression.not_in_list
      write "not in "
    else
      write "in "
    end

    if query = expression.query
      visit_query_source(query)
    end
    if values = expression.values
      write "("
      visit_list(values)
      remove_last_blank
      write ") "
    end
  end

  def visit(expression : Stealth::JoinExpression)
    visit_query_source(expression.left)
    write "#{expression.join_type} "
    visit_query_source(expression.right)

    if condition = expression.condition
      write "on "
      condition.accept(self)
    end
  end

  def to_sql : String
    sql_string_builder.to_s
  end

  protected def visit_list(expressions : Array(Stealth::SqlExpression))
    expressions.each_with_index do |expression, idx|
      if idx > 0
        remove_last_blank
        write ", "
      end

      expression.accept(self)
    end
  end

  protected def visit_column_assignments(assignments : Array(BaseColumnAssignmentExpression))
    assignments.each_with_index do |assignment, idx|
      if idx > 0
        remove_last_blank
        write ", "
      end

      write "#{quoted(assignment.column.name)} = "
      assignment.expression.accept(self)
    end
  end

  protected def visit_query_source(expression : QuerySourceExpression)
    case expression
    when TableExpression, JoinExpression
      expression.accept(self)
    when QueryExpression
      write "("
      expression.accept(self)
      remove_last_blank
      write ")"
      expression.table_alias.try { |it| write "#{quoted(it)} " }
    end
  end

  protected def write_insert_column_names(columns : Array(BaseColumnExpression))
    write "("
    columns.each_with_index do |column, idx|
      write ", " if idx > 0
      write quoted(column.name)
    end
    write ") "
  end

  protected def write_insert_values(assignments : Array(BaseColumnAssignmentExpression))
    write "("
    visit_list(assignments.map(&.expression))
    remove_last_blank
    write ") "
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

  protected def wrap_in_parens
    write "("
    yield
    remove_last_blank
    write ") "
  end
end
