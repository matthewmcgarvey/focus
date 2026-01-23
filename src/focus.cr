require "db"
require "json"

require "./focus/queryable"
require "./focus/expression"
require "./focus/readable_table"
require "./focus/updateable_table"
require "./focus/serializable_table"
require "./focus/select_table"
require "./focus/*"
require "./focus/tokens/*"
require "./focus/expressions/bool_expression"
require "./focus/expressions/numeric_expression"
require "./focus/expressions/*"
require "./focus/clauses/*"
require "./focus/statements/*"
require "./focus/columns/*"
require "./focus/dsl/*"
require "./focus/sql/*"
require "./focus/visitors/*"

module Focus
  VERSION = "0.1.0"

  alias DBConn = DB::Database | DB::Connection
end
