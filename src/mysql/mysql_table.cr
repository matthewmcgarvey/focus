class Focus::MySqlTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::MySqlDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::MySql::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    select_clause = Focus::SelectClause.new(projections)
    Focus::MySql::SelectStatement.new(select_clause)
  end

  def select : Focus::MySql::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select(projection)
  end
end
