class Focus::Query
  include Enumerable(Focus::CachedRow)

  getter database : Focus::Database
  getter expression : Focus::SelectExpression

  def initialize(@database : Focus::Database, @expression : Focus::SelectExpression)
  end

  def each(&block : Focus::CachedRow -> Nil)
    rows.each do |row|
      yield row
    end
  end

  @rows : Array(Focus::CachedRow)?

  def rows : Array(Focus::CachedRow)
    @rows ||= begin
      rows = [] of Focus::CachedRow
      result_set = database.execute_query(expression)
      begin
        result_set.each do
          rows << Focus::CachedRow.build(result_set)
        end
      ensure
        result_set.close
      end
      rows
    end
  end

  def bind_to(entity : T.class) : Array(T) forall T
    rows.map(&.bind_to(entity))
  end

  def bind_to_one?(entity : T.class, at index : Int32) : T? forall T
    drop(index)
      .take(1)
      .first?
      .try(&.bind_to(entity))
  end

  def bind_to_one(entity : T.class, at index : Int32) : T forall T
    bind_to_one?(entity, index).not_nil!
  end

  def bind_to_first?(entity : T.class) : T? forall T
    bind_to_one?(entity, at: 0)
  end

  def bind_to_first(entity : T.class) : T forall T
    bind_to_one(entity, at: 0)
  end

  def bind_to_last?(entity : T.class) : T? forall T
    rows.last.try(&.bind_to(entity))
  end

  def bind_to_last(entity : T.class) : T forall T
    bind_to_last?(entity).not_nil!
  end

  def to_sql : String
    result = database.format_expression(expression)
    "#{result.first} #{result[1].map(&.value)}"
  end

  def where(condition : Focus::ScalarExpression(Bool)) : Focus::Query
    new_expression = expression.copy(where: condition)
    Focus::Query.new(database, new_expression)
  end

  def where_with_conditions(&block : Array(ColumnDeclaring(Bool)) -> Nil) : Focus::Query
    conditions = [] of ColumnDeclaring(Bool)
    yield conditions
    return self if conditions.empty?

    condition = conditions.reduce { |a, b| a.and b }
    where condition.as(Focus::ScalarExpression(Bool))
  end

  def where_with_or_conditions(&block : Array(ColumnDeclaring(Bool)) -> Nil) : Focus::Query
    conditions = [] of ColumnDeclaring(Bool)
    yield conditions
    return self if conditions.empty?

    condition = conditions.reduce { |a, b| a.or b }
    where condition.as(Focus::ScalarExpression(Bool))
  end

  def group_by(*columns : BaseColumnDeclaring) : Query
    group_by(columns.to_a)
  end

  def group_by(columns : Array(BaseColumnDeclaring)) : Query
    new_expression = expression.copy(group_by: columns.map(&.as_expression.as(BaseScalarExpression)))
    Focus::Query.new(database, new_expression)
  end

  def having(condition : ColumnDeclaring(Bool)) : Query
    new_expression = expression.copy(having: condition.as_expression)
    Focus::Query.new(database, new_expression)
  end

  def order_by(*orders : OrderByExpression) : Query
    order_by(orders.to_a)
  end

  def order_by(orders : Array(OrderByExpression)) : Query
    new_expression = expression.copy(order_by: orders)
    Focus::Query.new(database, new_expression)
  end

  def limit(offset : Int32?, limit : Int32?) : Query
    new_limit = limit.try { |lim| lim > 0 ? lim : nil } || expression.limit
    new_offset = offset.try { |off| off > 0 ? off : nil } || expression.offset
    new_expression = expression.copy(limit: new_limit, offset: new_offset)
    Focus::Query.new(database, new_expression)
  end

  def limit(limit : Int32) : Query
    limit(limit: limit, offset: nil)
  end

  def offset(offset : Int32) : Query
    limit(limit: nil, offset: offset)
  end

  def drop(n : Int32) : Query
    if n.zero?
      self
    else
      offset = expression.offset || 0
      new_expression = expression.copy(offset: offset + n)
      Query.new(database, new_expression)
    end
  end

  def take(n : Int32) : Query
    limit = expression.limit || Int32::MAX
    new_expression = expression.copy(limit: Math.min(limit, n))
    Query.new(database, new_expression)
  end

  def any? : Bool
    count > 0
  end

  def none? : Bool
    count.zero?
  end

  def count : Int32
    aggregate_columns(Focus.count).not_nil!
  end

  def sum_by(selector : ColumnDeclaring(T)) : T? forall T
    aggregate_columns(Focus.sum(selector))
  end

  def max_by(selector : ColumnDeclaring(T)) : T? forall T
    aggregate_columns(Focus.max(selector))
  end

  def min_by(selector : ColumnDeclaring(T)) : T? forall T
    aggregate_columns(Focus.min(selector))
  end

  def average_by(selector : BaseColumnDeclaring) : Float32?
    aggregate_columns(Focus.avg(selector))
  end

  def aggregate_columns(aggregation : ColumnDeclaring(T)) : T? forall T
    new_expression = expression.copy(columns: [aggregation.aliased(nil).as(BaseColumnDeclaringExpression)])
    new_query = Query.new(database, new_expression)
    row = new_query.rows.first
    row.get?(0, T)
  end
end
