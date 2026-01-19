module Focus::SQLite::Dsl::Types
  def date(year : Int32, month : Int8, day : Int8) : Focus::DateExpression
    time_str = sprintf("%04d-%02d-%02d", {year, month, day})
    literal = Focus::LiteralExpression.new(time_str)
    func = Focus::FunctionExpression.new("DATE", [literal] of Focus::Expression)
    Focus::DateExpression.new(func)
  end

  def date(time : Time) : Focus::DateExpression
    literal = Focus::LiteralExpression.new(time)
    func = Focus::FunctionExpression.new("DATE", [literal] of Focus::Expression)
    Focus::DateExpression.new(func)
  end

  def datetime(year : Int32, month : Int8, day : Int8, hour : Int8, minute : Int8, second : Int8, nanoseconds : Int32? = nil) : Focus::TimestampExpression
    time_str = sprintf("%04d-%02d-%02d %02d:%02d:%02d", {year, month, day, hour, minute, second})
    time_str += format_nanoseconds(nanoseconds) if nanoseconds
    literal = Focus::LiteralExpression.new(time_str)
    func = Focus::FunctionExpression.new("DATETIME", [literal] of Focus::Expression)
    Focus::TimestampExpression.new(func)
  end

  def datetime(time : Time) : Focus::TimestampExpression
    literal = Focus::LiteralExpression.new(time)
    func = Focus::FunctionExpression.new("DATETIME", [literal] of Focus::Expression)
    Focus::TimestampExpression.new(func)
  end

  # max is 999
  # value like 300 will have trailing '0's removed leaving only '3'
  private def format_nanoseconds(nanoseconds : Int32)
    return "" if nanoseconds == 0

    '.' + sprintf("%09d", nanoseconds).rstrip('0')
  end
end
