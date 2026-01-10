require "pg"
require "./pg/*"
require "./pg/statements/*"

module Focus::PG
  def self.select(projections : Array(Focus::ProjectionExpression)) : Focus::PG::SelectStatement
    select_clause = Focus::SelectClause.new(projections)
    Focus::PG::SelectStatement.new(select_clause)
  end

  def self.select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::PG::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    self.select(projections)
  end

  def self.select : Focus::PG::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select([projection])
  end
end
