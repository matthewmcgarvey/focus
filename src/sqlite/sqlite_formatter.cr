class Focus::SQLiteFormatter < Focus::SqlFormatter
  def visit(expression : Focus::ArgumentExpression)
    write "? "
    parameters << expression
  end

  protected def write_pagination(expr : QueryExpression)
    write "limit ?, ? "
    parameters << ArgumentExpression.new(expr.offset || 0, Int32)
    parameters << ArgumentExpression.new(expr.limit || Int32::MAX, Int32)
  end
end
