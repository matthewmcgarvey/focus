module Focus::PG::Dsl::ArrayTypes
  def bool_array(values : Array(Bool)) : Focus::ArrayExpression(BoolExpression)
    exprs = values.map { |val| self.bool(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_bool_array
  end

  def string_array(values : Array(String)) : Focus::ArrayExpression(StringExpression)
    exprs = values.map { |val| self.string(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_string_array
  end

  def int32_array(values : Array(Int32)) : Focus::ArrayExpression(IntExpression(Int32))
    exprs = values.map { |val| self.int32(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_int32_array
  end

  def int64_array(values : Array(Int64)) : Focus::ArrayExpression(IntExpression(Int64))
    exprs = values.map { |val| self.int64(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_int64_array
  end

  def float32_array(values : Array(Float32)) : Focus::ArrayExpression(FloatExpression(Float32))
    exprs = values.map { |val| self.float32(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_float32_array
  end

  def float64_array(values : Array(Float64)) : Focus::ArrayExpression(FloatExpression(Float64))
    exprs = values.map { |val| self.float64(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_float64_array
  end

  def date_array(values : Array(Time)) : Focus::ArrayExpression(DateExpression)
    exprs = values.map { |val| Focus::DateLiteral.new(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_date_array
  end

  def time_array(values : Array(Time)) : Focus::ArrayExpression(TimeExpression)
    exprs = values.map { |val| Focus::LiteralExpression.new(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_time_array
  end

  def timestamp_tz_array(values : Array(Time)) : Focus::ArrayExpression(TimestampTzExpression)
    exprs = values.map { |val| Focus::LiteralExpression.new(val) }
    self.cast(Focus::ArrayLiteral.new(exprs)).as_timestamp_tz_array
  end
end
