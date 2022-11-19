require "db"

require "./focus/sql_expression"
require "./focus/column_declaring"
require "./focus/*"
require "./focus/dsl/*"

module Focus
  extend Focus::Dsl::Aggregation
  extend Focus::Dsl::TopLevelOperators
  VERSION = "0.1.0"

  # TODO: Put your code here
end
