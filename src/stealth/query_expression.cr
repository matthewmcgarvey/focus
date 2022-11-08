require "./query_source_expression"

module Stealth::QueryExpression
  include Stealth::QuerySourceExpression

  getter table_alias : String?
end
