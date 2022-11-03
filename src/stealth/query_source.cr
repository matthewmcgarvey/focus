class Stealth::QuerySource
  getter database : Stealth::Database
  getter table : Stealth::Table
  getter expression : Stealth::QuerySourceExpression

  def initialize(@database : Stealth::Database, @table : Stealth::Table, @expression : Stealth::QuerySourceExpression)
  end

  def select(*columns : Stealth::BaseColumn) : Stealth::Query
    select_expression = Stealth::SelectExpression.new(columns: columns.map(&.as_expression).to_a, from: expression)
    Stealth::Query.new(database: database, expression: select_expression)
  end
end
