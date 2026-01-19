require "sqlite3"
require "./sqlite/*"
require "./sqlite/statements/*"
require "./sqlite/dsl/*"

module Focus::SQLite
  extend Focus::Dsl::Aggregation
  extend Focus::Dsl::Columns
  extend Focus::Dsl::Types
  extend Focus::Dsl::MathFunctions
  extend Focus::Dsl::StringFunctions
  extend Focus::Dsl::ConditionalFunctions
  extend Focus::SQLite::Dsl::Types
  extend Focus::SQLite::Dsl::TimeFunctions

  def self.select(expressions : Array(Focus::Expression)) : Focus::SQLite::SelectStatement
    select_clause = Focus::SelectClause.new(expressions.select(Focus::Expression))
    Focus::SQLite::SelectStatement.new(select_clause)
  end

  def self.select(*fields : Focus::Expression | Array(Focus::Expression)) : Focus::SQLite::SelectStatement
    expressions = fields.to_a.flatten.select(Focus::Expression)
    self.select(expressions)
  end

  def self.select : Focus::SQLite::SelectStatement
    self.select([Focus::WildcardExpression.new.as(Focus::Expression)])
  end

  def self.with(*ctes : Focus::CommonTableExpression) : Focus::SQLite::WithStatement
    Focus::SQLite::WithStatement.new(ctes.to_a)
  end

  def self.cast(expression : Focus::Expression) : Focus::CastExpression
    Focus::CastExpression.new(expression)
  end

  def self.sql(&)
    with self yield
  end
end
