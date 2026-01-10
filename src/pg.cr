require "pg"
require "./pg/*"
require "./pg/statements/*"

module Focus::PG
  def self.select(projections : Array(Focus::ProjectionExpression)) : Focus::PG::SelectStatement
    select_clause = Focus::SelectClause.new(projections)
    Focus::PG::SelectStatement.new(select_clause)
  end

  def self.select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression | Array(Focus::Column)) : Focus::PG::SelectStatement
    projections = [] of Focus::ProjectionExpression
    fields.each do |field|
      if field.is_a?(Array(Focus::Column))
        projections.concat(field.map(&.to_projection))
      elsif field.is_a?(Focus::Column) || field.is_a?(Focus::AggregateExpression) || field.is_a?(Focus::ProjectionExpression)
        projections << field.to_projection
      end
    end
    self.select(projections)
  end

  def self.select : Focus::PG::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select([projection])
  end
end
