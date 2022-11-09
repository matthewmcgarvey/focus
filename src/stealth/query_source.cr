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

  def select : Stealth::Query
    select_expression = Stealth::SelectExpression.new(from: expression)
    Stealth::Query.new(database: database, expression: select_expression)
  end

  def select_distinct(*columns : Stealth::BaseColumnDeclaring) : Stealth::Query
    self.select_distinct(columns.to_a)
  end

  def select_distinct(columns : Enumerable(Stealth::BaseColumnDeclaring)) : Stealth::Query
    columns = columns.map(&.as_declaring_expression).select(Stealth::BaseColumnDeclaringExpression) # cuz generics
    select_expression = Stealth::SelectExpression.new(columns: columns, from: expression, is_distinct: true)
    Stealth::Query.new(database: database, expression: select_expression)
  end

  def select_distinct : Stealth::Query
    select_expression = Stealth::SelectExpression.new(from: expression, is_distinct: true)
    Stealth::Query.new(database: database, expression: select_expression)
  end

  def cross_join(right : Stealth::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::CROSS_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def inner_join(right : Stealth::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::INNER_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def left_join(right : Stealth::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::LEFT_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def right_join(right : Stealth::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::RIGHT_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end
end
