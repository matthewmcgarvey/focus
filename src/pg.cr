require "pg"
require "./pg/*"
require "./pg/statements/*"
require "./pg/dsl/*"

module Focus::PG
  extend Focus::Dsl::Aggregation
  extend Focus::Dsl::Columns
  extend Focus::Dsl::Types
  extend Focus::Dsl::MathFunctions
  extend Focus::Dsl::StringFunctions
  extend Focus::Dsl::ConditionalFunctions
  extend Focus::PG::Dsl::Types

  def self.select(expressions : Array(Focus::Expression)) : Focus::PG::SelectStatement
    select_clause = Focus::SelectClause.new(expressions.select(Focus::Expression))
    Focus::PG::SelectStatement.new(select_clause)
  end

  def self.select(*fields : Focus::Expression | Array(Focus::Expression)) : Focus::PG::SelectStatement
    expressions = fields.to_a.flatten.select(Focus::Expression)
    self.select(expressions)
  end

  def self.select : Focus::PG::SelectStatement
    self.select([Focus::WildcardExpression.new.as(Focus::Expression)])
  end

  def self.with(*ctes : Focus::CommonTableExpression) : Focus::PG::WithStatement
    Focus::PG::WithStatement.new(ctes.to_a)
  end

  def self.cast(expression : Focus::Expression) : Focus::CastExpression
    Focus::CastExpression.new(expression)
  end
end
