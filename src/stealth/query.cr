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
      row_metadata = Stealth::RowMetadata.new
      begin
        result_set.each do
          rows << Stealth::CachedRow.build(result_set, row_metadata)
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
    new_expression = Stealth::SelectExpression.new(expression.columns, expression.from, where: condition)
    Stealth::Query.new(database, new_expression)
  end
end
