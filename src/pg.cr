require "pg"
require "./pg/*"
require "./pg/statements/*"

module Focus::PG
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
end
