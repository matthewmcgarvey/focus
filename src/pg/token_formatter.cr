class Focus::PG::TokenFormatter < Focus::TokenFormatter
  property argument_counter = 1

  def visit_statement(statement : Focus::PG::LockStatement) : Nil
    emit Sql::Keyword.new("LOCK TABLE")
    statement.table.accept(self)
    emit Sql::Keyword.new("IN")
    emit Sql::Keyword.new(statement.lock_mode.to_s.gsub('_', ' '))
    emit Sql::Keyword.new("MODE")
    emit Sql::Keyword.new("NOWAIT") if statement.no_wait?
  end

  def visit_expression(expression : Focus::ArrayExpression(T)) : Nil forall T
    expression.inner.try(&.accept(self))
  end

  def visit_literal(literal : Focus::ArrayLiteral(T)) : Nil forall T
    emit Sql::Keyword.new("ARRAY")
    emit Sql::GroupStart.new('[')
    visit_list literal.value
    emit Sql::GroupEnd.new(']')
  end

  protected def render_placeholder(io : IO, next_token : Sql::Token?) : Nil
    io << "$#{argument_counter}"
    io << " " unless next_token.is_a?(Sql::GroupEnd) || next_token.is_a?(Sql::ListSeparator)
    self.argument_counter += 1
  end
end
