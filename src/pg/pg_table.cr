class Focus::PGTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::PGDialect.new

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::PG::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    select_clause = Focus::SelectClause.new(projections)
    Focus::PG::SelectStatement.new(select_clause).from(self)
  end

  def select : Focus::PG::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select(projection)
  end
end
