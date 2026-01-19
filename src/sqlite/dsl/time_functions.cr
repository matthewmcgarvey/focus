module Focus::SQLite::Dsl::TimeFunctions
  def current_date : Focus::DateExpression
    func = Focus::FunctionExpression.new("CURRENT_DATE", no_brackets: true)
    Focus::DateExpression.new(func)
  end

  def current_time : Focus::TimeExpression
    func = Focus::FunctionExpression.new("CURRENT_TIME", no_brackets: true)
    Focus::TimeExpression.new(func)
  end

  def current_timestamp : Focus::TimestampExpression
    func = Focus::FunctionExpression.new("CURRENT_TIMESTAMP", no_brackets: true)
    Focus::TimestampExpression.new(func)
  end
end
