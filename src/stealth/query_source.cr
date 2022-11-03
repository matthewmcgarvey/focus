class Stealth::QuerySource
  getter database : Stealth::Database
  getter table : Stealth::Table
  getter expression : Stealth::TableExpression

  def initialize(@database : Stealth::Database, @table : Stealth::Table, @expression : Stealth::TableExpression)
  end

  def select(*columns : Stealth::BaseColumn) : Stealth::Query
    columns = columns.map(&.as_expression)
      .to_a
      .select(Stealth::BaseColumnExpression) # cuz generics
    select_expression = Stealth::SelectExpression.new(columns: columns, from: expression)
    Stealth::Query.new(database: database, expression: select_expression)
  end
end
