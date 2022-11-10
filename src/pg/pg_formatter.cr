class Stealth::PGFormatter < Stealth::SqlFormatter
  property argument_counter = 1

  def visit(expression : TableExpression)
    if catalog = expression.catalog.presence
      write "#{quoted(catalog)}."
    end
    if schema = expression.schema.presence
      write "#{quoted(schema)}."
    end
    write "#{quoted(expression.name)} "

    if table_alias = expression.table_alias.presence
      write "as #{quoted(table_alias)} "
    end
  end

  def visit(expression : Stealth::ArgumentExpression)
    write "$#{argument_counter} "
    parameters << expression
    self.argument_counter += 1
  end

  def visit(expression : Stealth::ILikeExpression)
    if expression.left.wrap_in_parens?
      wrap_in_parens do
        expression.left.accept(self)
      end
    else
      expression.left.accept(self)
    end
    write "ilike "
    if expression.right.wrap_in_parens?
      wrap_in_parens do
        expression.right.accept(self)
      end
    else
      expression.right.accept(self)
    end
  end

  protected def write_pagination(expr : QueryExpression)
    if limit = expr.limit
      write "limit ? "
      parameters << ArgumentExpression.new(limit, Int32)
    end
    if offset = expr.offset
      write "offset ? "
      parameters << ArgumentExpression.new(offset, Int32)
    end
  end
end
