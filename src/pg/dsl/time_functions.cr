module Focus::PG::Dsl::TimeFunctions
  def current_date : Focus::DateExpression
    func = Focus::FunctionExpression.new("CURRENT_DATE", no_brackets: true)
    Focus::DateExpression.new(func)
  end

  def current_time : Focus::TimeExpression
    func = Focus::FunctionExpression.new("CURRENT_TIME", no_brackets: true)
    Focus::TimeExpression.new(func)
  end

  def current_timestamp : Focus::TimestampTzExpression
    func = Focus::FunctionExpression.new("CURRENT_TIMESTAMP", no_brackets: true)
    Focus::TimestampTzExpression.new(func)
  end

  def now : Focus::TimestampTzExpression
    func = Focus::FunctionExpression.new("NOW", parameters: [] of Focus::Expression)
    Focus::TimestampTzExpression.new(func)
  end

  def age(timestamp : Focus::TimestampExpression) : Focus::IntervalExpression
    func = Focus::FunctionExpression.new("AGE", parameters: [timestamp] of Focus::Expression)
    Focus::IntervalExpression.new(func)
  end

  def age(timestamp : Focus::TimestampTzExpression) : Focus::IntervalExpression
    func = Focus::FunctionExpression.new("AGE", parameters: [timestamp] of Focus::Expression)
    Focus::IntervalExpression.new(func)
  end

  def age(timestamp1 : Focus::TimestampExpression, timestamp2 : Focus::TimestampExpression) : Focus::IntervalExpression
    func = Focus::FunctionExpression.new("AGE", parameters: [timestamp1, timestamp2] of Focus::Expression)
    Focus::IntervalExpression.new(func)
  end

  def age(timestamp1 : Focus::TimestampTzExpression, timestamp2 : Focus::TimestampTzExpression) : Focus::IntervalExpression
    func = Focus::FunctionExpression.new("AGE", parameters: [timestamp1, timestamp2] of Focus::Expression)
    Focus::IntervalExpression.new(func)
  end
end
