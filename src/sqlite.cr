require "sqlite3"
require "./sqlite/*"
require "./sqlite/statements/*"

module Focus::SQLite
  def self.select(projections : Array(Focus::ProjectionExpression)) : Focus::SQLite::SelectStatement
    select_clause = Focus::SelectClause.new(projections)
    Focus::SQLite::SelectStatement.new(select_clause)
  end

  def self.select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::SQLite::SelectStatement
    projections = fields.map do |field|
      if field.is_a?(Focus::ProjectionExpression)
        field
      else
        Focus::ProjectionExpression.new(field)
      end
    end.to_a
    self.select(projections)
  end

  def self.select : Focus::SQLite::SelectStatement
    projection = Focus::ProjectionExpression.new(Focus::WildcardExpression.new)
    self.select([projection])
  end
end
