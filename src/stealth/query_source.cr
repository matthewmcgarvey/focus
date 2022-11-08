class Stealth::QuerySource
  getter database : Stealth::Database
  getter table : Stealth::Table
  getter expression : Stealth::QuerySourceExpression

  def initialize(@database, @table, @expression)
  end

  def select(*columns : Stealth::BaseColumnDeclaring) : Stealth::Query
    self.select(columns.to_a)
  end

  def select(columns : Enumerable(Stealth::BaseColumnDeclaring)) : Stealth::Query
    columns = columns.map(&.as_declaring_expression).select(Stealth::BaseColumnDeclaringExpression) # cuz generics
    select_expression = Stealth::SelectExpression.new(columns: columns, from: expression)
    Stealth::Query.new(database: database, expression: select_expression)
  end
end
