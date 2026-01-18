class Focus::CastExpression < Focus::Expression
  getter expression : Focus::Expression
  getter cast_type : String?

  def initialize(@expression : Focus::Expression, @cast_type : String? = nil)
  end

  def as_type(cast_type : String) : self
    @cast_type = cast_type
    self
  end

  def as_text : Focus::StringExpression
    Focus::StringExpression.new(as_type("TEXT"))
  end

  def as_numeric : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new(as_type("NUMERIC"))
  end

  def as_integer : Focus::IntExpression(Int32)
    Focus::IntExpression(Int32).new(as_type("INTEGER"))
  end

  def as_date : Focus::DateExpression
    Focus::DateExpression.new(as_type("DATE"))
  end

  def as_timestamp : Focus::TimestampExpression
    Focus::TimestampExpression.new(as_type("TIMESTAMP"))
  end

  def as_timestamp_tz : Focus::TimestampTzExpression
    Focus::TimestampTzExpression.new(as_type("TIMESTAMPTZ"))
  end
end
