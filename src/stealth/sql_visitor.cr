class Stealth::SqlVisitor
  WHITESPACE_BYTE = 32_u8

  private getter sql_string_builder = String::Builder.new
  getter parameters = [] of Stealth::BaseArgumentExpression

  def visit(expression : Stealth::SelectExpression)
    write "SELECT "
    visit_list(expression.columns)
    expression.from.accept(self)
    if where = expression.where
      write "WHERE "
      where.accept(self)
    end
    remove_last_blank
    write ";"
  end

  def visit(expression : Stealth::BaseColumnExpression)
    write "#{expression.name} "
  end

  def visit(expression : Stealth::TableExpression)
    write "FROM #{expression.name} "
  end

  def visit(expression : Stealth::BinaryExpression(_))
    expression.left.accept(self)
    write "#{expression.operator} "
    expression.right.accept(self)
  end

  def visit(expression : Stealth::UnaryExpression(_))
    case expression.type
    when Stealth::UnaryExpressionType::IS_NULL, Stealth::UnaryExpressionType::IS_NOT_NULL
      expression.operand.accept(self)
      write "#{expression.operator} "
    else
      write "#{expression.operator} "
      expression.operand.accept(self)
    end
  end

  def visit(expression : Stealth::ArgumentExpression)
    write "? "
    parameters << expression
  end

  def visit(expression : Stealth::BetweenExpression(_))
    expression.expression.accept(self)
    write "between "
    expression.lower.accept(self)
    write "and "
    expression.upper.accept(self)
  end

  def visit_list(expressions : Array(Stealth::SqlExpression))
    expressions.each_with_index do |expression, idx|
      if idx > 0
        remove_last_blank
        write ", "
      end

      expression.accept(self)
    end
  end

  def to_sql : String
    sql_string_builder.to_s
  end

  protected def remove_last_blank
    sql_string_builder.chomp!(WHITESPACE_BYTE)
  end

  protected def write(str : String)
    sql_string_builder << str
  end
end
