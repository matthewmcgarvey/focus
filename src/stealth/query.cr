class Stealth::Query
  include Enumerable(Stealth::CachedRow)

  getter database : Stealth::Database
  getter expression : Stealth::SelectExpression

  def initialize(@database : Stealth::Database, @expression : Stealth::SelectExpression)
  end

  def each(&block : Stealth::CachedRow -> Nil)
    rows.each do |row|
      yield row
    end
  end

  @rows : Array(Stealth::CachedRow)?

  def rows : Array(Stealth::CachedRow)
    @rows ||= begin
      rows = [] of Stealth::CachedRow
      result_set = database.execute_query(expression)
      begin
        result_set.each do
          rows << Stealth::CachedRow.build(result_set)
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

  def to_sql : String
    result = database.format_expression(expression)
    "#{result.first} #{result[1].map(&.value)}"
  end

  def where(condition : Stealth::ScalarExpression(Bool)) : Stealth::Query
    new_expression = expression.copy(where: condition)
    Stealth::Query.new(database, new_expression)
  end

  def where_with_conditions(&block : Array(ColumnDeclaring(Bool)) -> Nil) : Stealth::Query
    conditions = [] of ColumnDeclaring(Bool)
    yield conditions
    return self if conditions.empty?

    condition = conditions.reduce { |a, b| a.and b }
    where condition.as(Stealth::ScalarExpression(Bool))
  end

  def where_with_or_conditions(&block : Array(ColumnDeclaring(Bool)) -> Nil) : Stealth::Query
    conditions = [] of ColumnDeclaring(Bool)
    yield conditions
    return self if conditions.empty?

    condition = conditions.reduce { |a, b| a.or b }
    where condition.as(Stealth::ScalarExpression(Bool))
  end

  def group_by(*columns : BaseColumnDeclaring) : Query
    group_by(columns.to_a)
  end

  def group_by(columns : Array(BaseColumnDeclaring)) : Query
    new_expression = expression.copy(group_by: columns.map(&.as_expression.as(BaseScalarExpression)))
    Stealth::Query.new(database, new_expression)
  end

  def having(condition : ColumnDeclaring(Bool)) : Query
    new_expression = expression.copy(having: condition.as_expression)
    Stealth::Query.new(database, new_expression)
  end

  def order_by(*orders : OrderByExpression) : Query
    order_by(orders.to_a)
  end

  def order_by(orders : Array(OrderByExpression)) : Query
    new_expression = expression.copy(order_by: orders)
    Stealth::Query.new(database, new_expression)
  end

  def limit(offset : Int32?, limit : Int32?) : Query
    new_limit = limit.try { |lim| lim > 0 ? lim : nil } || expression.limit
    new_offset = offset.try { |off| off > 0 ? off : nil } || expression.offset
    new_expression = expression.copy(limit: new_limit, offset: new_offset)
    Stealth::Query.new(database, new_expression)
  end

  def limit(limit : Int32) : Query
    limit(limit: limit, offset: nil)
  end

  def offset(offset : Int32) : Query
    limit(limit: nil, offset: offset)
  end

  def any? : Bool
    count > 0
  end

  def none? : Bool
    count.zero?
  end

  def count : Int32
    aggregate_columns(Stealth.count).not_nil!
  end

  def aggregate_columns(aggregation : ColumnDeclaring(T)) : T? forall T
    new_expression = expression.copy(columns: [aggregation.aliased(nil).as(BaseColumnDeclaringExpression)])
    new_query = Query.new(database, new_expression)
    row = new_query.rows.first
    row.get?(0, T)
  end
end
