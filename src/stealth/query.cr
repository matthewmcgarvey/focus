class Stealth::Query
  include Enumerable(Stealth::CachedRow)

  getter database : Stealth::Database
  getter expression : Stealth::QueryExpression

  def initialize(@database : Stealth::Database, @expression : Stealth::QueryExpression)
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
          rows << Stealth::CachedRow.from_result_set(result_set)
        end
      ensure
        result_set.close
      end
      rows
    end
  end

  def to_sql : String
    database.to_sql(expression)
  end
end
