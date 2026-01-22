class Focus::PG::CastExpression < Focus::CastExpression
  def as_bool_array : Focus::ArrayExpression(BoolExpression)
    Focus::ArrayExpression(BoolExpression).new(as_type("BOOLEAN[]"))
  end

  def as_string_array : Focus::ArrayExpression(StringExpression)
    Focus::ArrayExpression(StringExpression).new(as_type("TEXT[]"))
  end

  def as_int32_array : Focus::ArrayExpression(IntExpression(Int32))
    Focus::ArrayExpression(IntExpression(Int32)).new(as_type("INTEGER[]"))
  end

  def as_int64_array : Focus::ArrayExpression(IntExpression(Int64))
    Focus::ArrayExpression(IntExpression(Int64)).new(as_type("BIGINT[]"))
  end

  def as_float32_array : Focus::ArrayExpression(FloatExpression(Float32))
    Focus::ArrayExpression(FloatExpression(Float32)).new(as_type("REAL[]"))
  end

  def as_float64_array : Focus::ArrayExpression(FloatExpression(Float64))
    Focus::ArrayExpression(FloatExpression(Float64)).new(as_type("DOUBLE[]"))
  end

  def as_date_array : Focus::ArrayExpression(DateExpression)
    Focus::ArrayExpression(DateExpression).new(as_type("DATE[]"))
  end

  def as_time_array : Focus::ArrayExpression(TimeExpression)
    Focus::ArrayExpression(TimeExpression).new(as_type("TIME WITHOUT TIME ZONE[]"))
  end

  def as_timestamp_tz_array : Focus::ArrayExpression(TimestampTzExpression)
    Focus::ArrayExpression(TimestampTzExpression).new(as_type("TIMESTAMP WITH TIME ZONE[]"))
  end
end
