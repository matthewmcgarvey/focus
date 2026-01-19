module Focus::PG::Dsl::Types
  def date(year : Int32, month : Int8, day : Int8) : Focus::DateExpression
    time_str = sprintf("%04d-%02d-%02d", {year, month, day})
    literal = Focus::LiteralExpression.new(time_str)
    date_expr = Focus::DateExpression.new(literal)
    Focus::PG.cast(date_expr).as_date
  end

  def date(time : Time) : Focus::DateExpression
    literal = Focus::LiteralExpression.new(time)
    date_expr = Focus::DateExpression.new(literal)
    Focus::PG.cast(date_expr).as_date
  end

  def timestamp(year : Int32, month : Int8, day : Int8, hour : Int8, minute : Int8, second : Int8, nanoseconds : Int32? = nil) : Focus::TimestampExpression
    time_str = sprintf("%04d-%02d-%02d %02d:%02d:%02d", {year, month, day, hour, minute, second})
    time_str += format_nanoseconds(nanoseconds) if nanoseconds
    literal = Focus::LiteralExpression.new(time_str)
    timestamp_expr = Focus::TimestampExpression.new(literal)
    Focus::PG.cast(timestamp_expr).as_timestamp
  end

  def timestamp(time : Time) : Focus::TimestampExpression
    literal = Focus::LiteralExpression.new(time)
    timestamp_expr = Focus::TimestampExpression.new(literal)
    Focus::PG.cast(timestamp_expr).as_timestamp
  end

  def timestamp_tz(year : Int32, month : Int8, day : Int8, hour : Int8, minute : Int8, second : Int8, nanoseconds : Int32, time_zone : String) : Focus::TimestampTzExpression
    time_str = sprintf("%04d-%02d-%02d %02d:%02d:%02d", {year, month, day, hour, minute, second})
    time_str += format_nanoseconds(nanoseconds)
    time_str += ' ' + time_zone
    literal = Focus::LiteralExpression.new(time_str)
    timestamp_expr = Focus::TimestampTzExpression.new(literal)
    Focus::PG.cast(timestamp_expr).as_timestamp_tz
  end

  def timestamp_tz(time : Time) : Focus::TimestampTzExpression
    literal = Focus::LiteralExpression.new(time)
    timestamp_expr = Focus::TimestampTzExpression.new(literal)
    Focus::PG.cast(timestamp_expr).as_timestamp_tz
  end

  def time(hour : Int8, minute : Int8, second : Int8, nanoseconds : Int32? = nil) : Focus::TimeExpression
    time_str = sprintf("%02d:%02d:%02d", {hour, minute, second})
    time_str += format_nanoseconds(nanoseconds) if nanoseconds
    literal = Focus::LiteralExpression.new(time_str)
    time_expr = Focus::TimeExpression.new(literal)
    Focus::PG.cast(time_expr).as_time
  end

  def interval(span : Time::Span) : Focus::IntervalExpression
    interval(format_interval(span))
  end

  def interval(value : String) : Focus::IntervalExpression
    literal = Focus::LiteralExpression.new(value)
    Focus::PG.cast(literal).as_interval
  end

  private def format_nanoseconds(nanoseconds : Int32)
    return "" if nanoseconds == 0

    '.' + sprintf("%09d", nanoseconds).rstrip('0')
  end

  private def format_interval(span : Time::Span) : String
    parts = [] of String
    parts << "#{span.days} #{span.days == 1 ? "day" : "days"}" if span.days != 0
    parts << "#{span.hours} #{span.hours == 1 ? "hour" : "hours"}" if span.hours != 0
    parts << "#{span.minutes} #{span.minutes == 1 ? "minute" : "minutes"}" if span.minutes != 0
    parts << "#{span.seconds} #{span.seconds == 1 ? "second" : "seconds"}" if span.seconds != 0
    parts.empty? ? "0 seconds" : parts.join(" ")
  end
end
