require "db"

require "./stealth/sql_expression"
require "./stealth/column_declaring"
require "./stealth/*"
require "./stealth/dsl/*"

module Stealth
  extend Stealth::Dsl::Aggregation
  extend Stealth::Dsl::TopLevelOperators
  VERSION = "0.1.0"

  # TODO: Put your code here
end
