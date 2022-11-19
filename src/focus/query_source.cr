class Focus::QuerySource
  getter database : Focus::Database
  getter table : Focus::Table
  getter expression : Focus::QuerySourceExpression

  def initialize(@database, @table, @expression)
  end

  def select(*columns : Focus::BaseColumnDeclaring) : Focus::Query
    self.select(columns.to_a)
  end

  def select(columns : Enumerable(Focus::BaseColumnDeclaring)) : Focus::Query
    columns = columns.map(&.as_declaring_expression).select(Focus::BaseColumnDeclaringExpression) # cuz generics
    select_expression = Focus::SelectExpression.new(columns: columns, from: expression)
    Focus::Query.new(database: database, expression: select_expression)
  end

  def select : Focus::Query
    select_expression = Focus::SelectExpression.new(from: expression)
    Focus::Query.new(database: database, expression: select_expression)
  end

  def select_distinct(*columns : Focus::BaseColumnDeclaring) : Focus::Query
    self.select_distinct(columns.to_a)
  end

  def select_distinct(columns : Enumerable(Focus::BaseColumnDeclaring)) : Focus::Query
    columns = columns.map(&.as_declaring_expression).select(Focus::BaseColumnDeclaringExpression) # cuz generics
    select_expression = Focus::SelectExpression.new(columns: columns, from: expression, is_distinct: true)
    Focus::Query.new(database: database, expression: select_expression)
  end

  def select_distinct : Focus::Query
    select_expression = Focus::SelectExpression.new(from: expression, is_distinct: true)
    Focus::Query.new(database: database, expression: select_expression)
  end

  def cross_join(right : Focus::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::CROSS_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def inner_join(right : Focus::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::INNER_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def left_join(right : Focus::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::LEFT_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end

  def right_join(right : Focus::Table, on : ColumnDeclaring(Bool)? = nil) : QuerySource
    new_expression = JoinExpression.new(
      type: JoinType::RIGHT_JOIN,
      left: expression,
      right: right.as_expression,
      condition: on.try(&.as_expression)
    )
    QuerySource.new(database, table, new_expression)
  end
end
