abstract class Focus::InsertStatement < Focus::Statement
  getter insert_clause : Focus::InsertClause
  getter values_clause : Focus::ValuesClause?
  getter query : Focus::QueryClause?
  getter conflict_clause : Focus::OnConflictClause?
  getter set : Focus::SetClause?
  getter returning : Focus::ReturningClause?

  def initialize(@insert_clause : Focus::InsertClause)
  end

  def values(*raw_values) : self
    @values_clause ||= Focus::ValuesClause.new
    clause = self.values_clause
    raise "unreachable" if clause.nil?

    row = [] of Focus::Expression
    raw_values.each do |raw|
      row << if raw.is_a?(Focus::Expression)
        raw
      else
        Focus::GenericValueExpression.new(raw)
      end
    end
    clause.add_row(row)
    self
  end

  def query(query : Focus::SelectStatement) : self
    @query = Focus::QueryClause.new(query)
    self
  end

  def on_conflict(*columns : Focus::Column) : self
    column_names = columns.map { |column| Focus::ColumnToken.new(column.as(Focus::Column).column_name) }
    @conflict_clause = Focus::OnConflictClause.new(column_names.to_a)
    self
  end

  def on_conflict : self
    column_names = [] of Focus::ColumnToken
    @conflict_clause = Focus::OnConflictClause.new(column_names)
    self
  end

  def do_update : self
    @conflict_clause.try(&.do_update)
    self
  end

  def do_nothing : self
    @conflict_clause.try(&.do_nothing)
    self
  end

  def set(column : Focus::Column, expr : Focus::Expression) : self
    @set ||= Focus::SetClause.new
    col_token = Focus::ColumnToken.new(column.column_name)
    @set.try(&.add_column(col_token, expr))
    self
  end

  def set(column : Focus::Column, val : T) : self forall T
    expr = Focus::GenericValueExpression.new(val)
    set(column, expr)
  end

  def returning(*returning_vals : Focus::Expression) : self
    @returning = Focus::ReturningClause.new(returning_vals.select(Focus::Expression))
    self
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::INSERT_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      insert_clause,
      values_clause,
      query,
      conflict_clause,
      set,
      returning,
    ].compact
  end
end
