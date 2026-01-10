require "db"

require "./focus/queryable"
require "./focus/expression"
require "./focus/joinable"
require "./focus/table_source"
require "./focus/column_macros"
require "./focus/updateable_table"
require "./focus/*"
require "./focus/tokens/*"
require "./focus/expressions/*"
require "./focus/clauses/*"
require "./focus/columns/*"
require "./focus/dsl/*"
require "./focus/visitors/*"

module Focus
  extend Focus::Dsl::Aggregation
  VERSION = "0.1.0"

  alias DBConn = DB::Database | DB::Connection

  def self.format_expression(expression : Focus::SqlExpression) : Tuple(String, Array(Focus::BaseArgumentExpression))
    visitor = Focus::SqlFormatter.new
    expression.accept(visitor)
    {visitor.to_sql, visitor.parameters}
  end

  def self.column(name : String, type : T.class) : Focus::Column(T) forall T
    Focus::Column(T).new(name)
  end
end
