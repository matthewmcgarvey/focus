# Token-based SQL formatter - emits tokens then renders them to SQL string.
# Separates structure decisions (what tokens to emit) from formatting (how to render).
class Focus::TokenFormatter < Focus::SqlVisitor
  # Reuse SqlFormatter's StatementType for compatibility
  alias StatementType = SqlFormatter::StatementType

  private property statement_type : StatementType?
  getter parameters : Array(DB::Any) = [] of DB::Any
  getter tokens = [] of Sql::Token
  private property skip_outer_parens : Bool = false

  protected def emit(token : Sql::Token)
    tokens << token
  end

  # --- Statement visitors ---

  def visit_statement(statement : Focus::WithStatement) : Nil
    self.statement_type = statement.statement_type
    emit Sql::Keyword.new("WITH")
    visit_list statement.ctes
    statement.primary_statement.try(&.accept(self))
  end

  def visit_statement(statement : Focus::SetStatement) : Nil
    self.statement_type = statement.statement_type
    statement.lhs.accept(self)
    emit Sql::Keyword.new(statement.operator.to_s.gsub('_', ' '))
    statement.rhs.accept(self)
    statement.order_by_clauses.try(&.accept(self))
    statement.limit_clause.try(&.accept(self))
    statement.offset_clause.try(&.accept(self))
  end

  def visit_statement(statement : Focus::Statement) : Nil
    self.statement_type = statement.statement_type
    statement.ordered_clauses.each(&.accept(self))
  end

  # --- Clause visitors ---

  def visit_clause(clause : Focus::SelectClause) : Nil
    emit Sql::Keyword.new("SELECT")
    if clause.distinct?
      emit Sql::Keyword.new("DISTINCT")
      distinct_on_columns = clause.distinct_on_columns
      if distinct_on_columns && !distinct_on_columns.empty?
        emit Sql::Keyword.new("ON")
        emit Sql::GroupStart.new
        visit_list distinct_on_columns
        emit Sql::GroupEnd.new
      end
    end
    visit_list(clause.projections)
  end

  def visit_clause(clause : Focus::UsingClause) : Nil
    emit Sql::Keyword.new("USING")
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::FromClause) : Nil
    emit Sql::Keyword.new("FROM")
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::WhereClause) : Nil
    emit Sql::Keyword.new("WHERE")
    visit_unwrapped(clause.expression)
  end

  def visit_clause(clause : Focus::OrderByListClause) : Nil
    emit Sql::Keyword.new("ORDER BY")
    visit_list clause.order_bys
  end

  def visit_clause(clause : Focus::OrderByClause) : Nil
    clause.expression.accept(self)
    case clause.order_type
    when Focus::OrderByClause::OrderType::ASCENDING
      emit Sql::Keyword.new("ASC")
    when Focus::OrderByClause::OrderType::DESCENDING
      emit Sql::Keyword.new("DESC")
    end
    clause.is_nulls_first.try do |nulls_first|
      emit Sql::Keyword.new("NULLS")
      emit Sql::Keyword.new(nulls_first ? "FIRST" : "LAST")
    end
  end

  def visit_clause(clause : Focus::LimitClause) : Nil
    emit Sql::Keyword.new("LIMIT")
    emit Sql::Placeholder.new(clause.limit)
    parameters << clause.limit
  end

  def visit_clause(clause : Focus::OffsetClause) : Nil
    emit Sql::Keyword.new("OFFSET")
    emit Sql::Placeholder.new(clause.offset)
    parameters << clause.offset
  end

  def visit_clause(clause : Focus::GroupByClause) : Nil
    emit Sql::Keyword.new("GROUP BY")
    visit_list clause.group_bys
  end

  def visit_clause(clause : Focus::HavingClause) : Nil
    emit Sql::Keyword.new("HAVING")
    visit_unwrapped(clause.expression)
  end

  def visit_clause(clause : Focus::InsertClause) : Nil
    emit Sql::Keyword.new("INSERT INTO")
    clause.table.accept(self)
    emit Sql::GroupStart.new
    visit_list(clause.columns)
    emit Sql::GroupEnd.new
  end

  def visit_clause(clause : Focus::ValuesClause) : Nil
    emit Sql::Keyword.new("VALUES")
    visit_list clause.rows
  end

  def visit_clause(clause : Focus::ValuesClause::Row) : Nil
    emit Sql::GroupStart.new
    visit_list(clause.values)
    emit Sql::GroupEnd.new
  end

  def visit_clause(clause : Focus::OnConflictClause) : Nil
    emit Sql::Keyword.new("ON CONFLICT")
    if !clause.columns.empty?
      emit Sql::GroupStart.new
      visit_list(clause.columns)
      emit Sql::GroupEnd.new
    end
    emit Sql::Keyword.new(clause.action.to_s)
  end

  def visit_clause(clause : Focus::QueryClause) : Nil
    clause.query.accept(self)
  end

  def visit_clause(clause : Focus::ReturningClause) : Nil
    emit Sql::Keyword.new("RETURNING")
    visit_list clause.columns
  end

  def visit_clause(clause : Focus::UpdateClause) : Nil
    emit Sql::Keyword.new("UPDATE")
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::SetClause) : Nil
    emit Sql::Keyword.new("SET")
    visit_list clause.set_columns
  end

  def visit_clause(clause : Focus::SetClause::Column) : Nil
    clause.column.accept(self)
    emit Sql::Operator.new("=")
    if clause.value.is_a?(Focus::Statement)
      emit Sql::GroupStart.new
      clause.value.accept(self)
      emit Sql::GroupEnd.new
    else
      clause.value.accept(self)
    end
  end

  def visit_clause(clause : Focus::DeleteClause) : Nil
    emit Sql::Keyword.new("DELETE FROM")
    clause.table.accept(self)
  end

  def visit_clause(clause : Focus::ForClause) : Nil
    emit Sql::Keyword.new("FOR")
    case clause.strength
    when .update?        then emit Sql::Keyword.new("UPDATE")
    when .no_key_update? then emit Sql::Keyword.new("NO KEY UPDATE")
    when .share?         then emit Sql::Keyword.new("SHARE")
    when .key_share?     then emit Sql::Keyword.new("KEY SHARE")
    end

    tables = clause.tables
    if tables && !tables.empty?
      emit Sql::Keyword.new("OF")
      visit_list tables
    end

    case clause.wait_policy
    when .nil?
      # do nothing
    when .nowait?
      emit Sql::Keyword.new("NOWAIT")
    when .skip_locked?
      emit Sql::Keyword.new("SKIP LOCKED")
    end
  end

  def visit_clause(clause : Focus::Clause) : Nil
    raise "shouldn't get here. implement #{clause.class} handling"
  end

  # --- Expression visitors ---

  def visit_expression(expression : Focus::AliasedExpression) : Nil
    expression.inner.accept(self)
    emit Sql::Keyword.new("AS")
    emit Sql::Identifier.new(expression.alias)
  end

  def visit_expression(expression : Focus::BetweenOperatorExpression) : Nil
    expression.expression.accept(self)
    emit Sql::Keyword.new("NOT") if expression.negated
    emit Sql::Keyword.new("BETWEEN")
    expression.min.accept(self)
    emit Sql::Keyword.new("AND")
    expression.max.accept(self)
  end

  def visit_expression(expression : Focus::ComplexExpression) : Nil
    if skip_outer_parens
      self.skip_outer_parens = false
      expression.inner.accept(self)
    else
      emit Sql::GroupStart.new
      expression.inner.accept(self)
      emit Sql::GroupEnd.new
    end
  end

  def visit_expression(expression : Focus::BoolExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::BinaryExpression) : Nil
    expression.left.accept(self)
    emit Sql::Operator.new(expression.operator)
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

  def visit_expression(expression : Focus::DateExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::TimestampExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::TimestampTzExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::TimeExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::IntervalExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::JsonbExpression) : Nil
    expression.inner.try(&.accept(self))
  end

  def visit_expression(expression : Focus::WildcardExpression) : Nil
    if table_name = expression.table_name
      emit Sql::Identifier.new("*", table: table_name)
    else
      emit Sql::Literal.new("*")
    end
  end

  def visit_expression(expression : Focus::AggregateExpression) : Nil
    emit Sql::Literal.new(expression.type.to_s)
    emit Sql::GroupStart.new
    expression.argument.accept(self)
    emit Sql::GroupEnd.new
  end

  def visit_expression(expression : Focus::FunctionExpression) : Nil
    name = expression.name.presence
    emit Sql::Literal.new(name) if name

    if !expression.no_brackets
      emit Sql::GroupStart.new
      visit_list(expression.parameters)
      emit Sql::GroupEnd.new
    end
  end

  def visit_expression(expression : Focus::CastExpression) : Nil
    emit Sql::Literal.new("CAST")
    emit Sql::GroupStart.new
    expression.expression.accept(self)
    emit Sql::Keyword.new("AS")
    emit Sql::Literal.new(expression.cast_type)
    emit Sql::GroupEnd.new
  end

  def visit_expression(expression : Focus::ValueExpression) : Nil
    emit Sql::Placeholder.new(expression.value)
    parameters << expression.value
  end

  def visit_expression(expression : Focus::PostfixOperatorExpression)
    expression.expression.accept(self)
    emit Sql::Operator.new(expression.operator)
  end

  def visit_expression(expression : Focus::PrefixOperatorExpression)
    emit Sql::Operator.new(expression.operator)
    expression.expression.accept(self)
  end

  def visit_expression(expression : Focus::Expression) : Nil
    raise "shouldn't get here. implement visit_expression for #{expression.class}"
  end

  # --- Literal visitors ---

  def visit_literal(literal : Focus::JsonbLiteral) : Nil
    emit Sql::Placeholder.new(literal.value.to_json)
    parameters << literal.value.to_json
  end

  def visit_literal(literal : Focus::Parameter) : Nil
    if !literal.is_a?(Focus::ArrayLiteral)
      emit Sql::Placeholder.new(literal.value)
      parameters << literal.value
    end
  end

  # --- Column visitor ---

  def visit_column(column : Focus::Column) : Nil
    if subquery = column.subquery
      emit Sql::Identifier.new(column.column_name, table: subquery.alias)
    elsif table_name = column.table_name
      emit Sql::Identifier.new(column.column_name, table: table_name)
    else
      emit Sql::Identifier.new(column.column_name)
    end
  end

  # --- Table visitors ---

  def visit_table(table : Focus::CommonTableExpression) : Nil
    if statement_type == StatementType::WITH_STMT_TYPE
      emit Sql::Identifier.new(table.alias)
      emit Sql::Keyword.new("AS")
      emit Sql::GroupStart.new
      table.statement.accept(self)
      emit Sql::GroupEnd.new
    else
      emit Sql::Identifier.new(table.alias)
    end
  end

  def visit_table(table : Focus::SelectTable) : Nil
    emit Sql::GroupStart.new
    table.statement.accept(self)
    emit Sql::GroupEnd.new
    emit Sql::Identifier.new(table.alias)
  end

  def visit_table(table : Focus::JoinTable) : Nil
    table.lhs.accept(self)

    case table.join_type
    when Focus::JoinTable::JoinType::INNER
      emit Sql::Keyword.new("INNER JOIN")
    when Focus::JoinTable::JoinType::LEFT
      emit Sql::Keyword.new("LEFT JOIN")
    when Focus::JoinTable::JoinType::RIGHT
      emit Sql::Keyword.new("RIGHT JOIN")
    when Focus::JoinTable::JoinType::CROSS
      emit Sql::Keyword.new("CROSS JOIN")
    end

    table.rhs.accept(self)
    if condition = table.condition
      emit Sql::Keyword.new("ON")
      visit_unwrapped(condition)
    end
  end

  def visit_table(table : Focus::Table) : Nil
    if schema_name = table.schema_name
      emit Sql::Identifier.new(table.table_name, schema: schema_name)
    else
      emit Sql::Identifier.new(table.table_name)
    end
    if table_alias = table.table_alias
      emit Sql::Identifier.new(table_alias)
    end
  end

  def visit_table(table : Focus::SerializableTable) : Nil
    raise "shouldn't get here. implement #{table.class} handling"
  end

  # --- Token visitors ---

  def visit_token(token : Focus::ColumnToken) : Nil
    emit Sql::Identifier.new(token.column)
  end

  def visit_token(token : Focus::Token) : Nil
    raise "shouldn't get here. implement #{token.class} handling"
  end

  # --- Output ---

  def to_sql : String
    String.build do |io|
      tokens.each_with_index do |token, idx|
        render_token(io, token, tokens[idx + 1]?)
      end
    end.strip
  end

  # --- Helper methods ---

  # Visit a BoolExpression without outer parentheses (for top-level contexts)
  private def visit_unwrapped(expression : Focus::BoolExpression) : Nil
    if inner = expression.inner
      if inner.is_a?(Focus::ComplexExpression)
        # Skip the ComplexExpression's parentheses
        self.skip_outer_parens = true
      end
      inner.accept(self)
    else
      expression.accept(self)
    end
  end

  protected def visit_list(expressions : Array)
    expressions.each_with_index do |expression, idx|
      emit Sql::ListSeparator.new if idx > 0

      if expression.is_a?(Focus::BoolExpression)
        visit_unwrapped(expression)
      else
        expression.accept(self)
      end
    end
  end

  # --- Token rendering ---

  protected def render_token(io : IO, token : Sql::Token, next_token : Sql::Token?) : Nil
    case token
    in Sql::Keyword
      io << token.text
      skip_space = next_token.is_a?(Sql::ListSeparator) ||
        (next_token.is_a?(Sql::GroupStart) && next_token.char == '[')
      io << " " unless skip_space
    in Sql::Identifier
      render_identifier(io, token)
      io << " " unless next_token.is_a?(Sql::GroupEnd) || next_token.is_a?(Sql::ListSeparator)
    in Sql::Operator
      io << token.text
      io << " "
    in Sql::Placeholder
      render_placeholder(io, next_token)
    in Sql::Literal
      io << token.text
      io << " " unless next_token.is_a?(Sql::GroupStart) || next_token.is_a?(Sql::GroupEnd) || next_token.is_a?(Sql::ListSeparator)
    in Sql::GroupStart
      io << token.char
    in Sql::GroupEnd
      io << token.char
      io << " " unless next_token.is_a?(Sql::GroupEnd) || next_token.is_a?(Sql::ListSeparator) || next_token.nil?
    in Sql::ListSeparator
      io << ", "
    in Sql::Token
      # Abstract base - shouldn't happen
    end
  end

  protected def render_identifier(io : IO, token : Sql::Identifier) : Nil
    if schema = token.schema
      write_identifier(io, schema)
      io << "."
    end
    if table = token.table
      write_identifier(io, table)
      io << "."
    end
    write_identifier(io, token.name)
  end

  protected def render_placeholder(io : IO, next_token : Sql::Token?) : Nil
    io << "?"
    io << " " unless next_token.is_a?(Sql::GroupEnd) || next_token.is_a?(Sql::ListSeparator)
  end

  protected def write_identifier(io : IO, name : String) : Nil
    if should_quote?(name)
      io << quoted(name)
    else
      io << name
    end
  end

  protected def should_quote?(str : String) : Bool
    str.each_char_with_index do |char, idx|
      next if (char.number? && idx > 0) || char == '_'
      return true if !char.letter? || char.uppercase?
    end
    false
  end

  protected def quoted(str : String) : String
    %["#{str}"]
  end
end
