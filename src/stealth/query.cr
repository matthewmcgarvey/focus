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

  def to_sql : String
    database.format_expression(expression).first
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
end
