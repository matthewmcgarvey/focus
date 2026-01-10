class Focus::SQLiteTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLiteDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::SQLite::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    select_clause = Focus::SelectClause.new(projections)
    Focus::SQLite::SelectStatement.new(select_clause)
  end

  def select : Focus::SQLite::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select(projection)
  end
end
