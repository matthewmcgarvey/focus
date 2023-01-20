class Focus::MySqlFormatter < Focus::SqlFormatter
  def visit(expression : Focus::ArgumentExpression)
    write "? "
    parameters << expression
  end

  protected def write_pagination(expr : QueryExpression)
    write "limit ?, ? "
    parameters << ArgumentExpression(Int32).new(expr.offset || 0)
    parameters << ArgumentExpression(Int32).new(expr.limit || Int32::MAX)
  end
end
