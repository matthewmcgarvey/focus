module Focus::Dsl::Types
  def int8(value : Int8) : Focus::IntExpression(Int8)
    Focus::IntLiteral(Int8).new(value)
  end

  def int16(value : Int16) : Focus::IntExpression(Int16)
    Focus::IntLiteral(Int16).new(value)
  end

  def int32(value : Int32) : Focus::IntExpression(Int32)
    Focus::IntLiteral(Int32).new(value)
  end

  def int64(value : Int64) : Focus::IntExpression(Int64)
    Focus::IntLiteral(Int64).new(value)
  end

  def uint8(value : UInt8) : Focus::IntExpression(UInt8)
    Focus::IntLiteral(UInt8).new(value)
  end

  def uint16(value : UInt16) : Focus::IntExpression(UInt16)
    Focus::IntLiteral(UInt16).new(value)
  end

  def uint32(value : UInt32) : Focus::IntExpression(UInt32)
    Focus::IntLiteral(UInt32).new(value)
  end

  def uint64(value : UInt64) : Focus::IntExpression(UInt64)
    Focus::IntLiteral(UInt64).new(value)
  end

  def float32(value : Float32) : Focus::FloatExpression(Float32)
    Focus::FloatLiteral(Float32).new(value)
  end

  def float64(value : Float64) : Focus::FloatExpression(Float64)
    Focus::FloatLiteral(Float64).new(value)
  end

  def bool(value : Bool) : Focus::BoolExpression
    Focus::BoolLiteral.new(value)
  end

  def string(value : String) : Focus::StringExpression
    Focus::StringLiteral.new(value)
  end

  def date(value : Time) : Focus::DateExpression
    Focus::DateLiteral.new(value)
  end

  def timestamp(value : Time) : Focus::TimestampExpression
    Focus::TimestampLiteral.new(value)
  end

  def timestamptz(value : Time) : Focus::TimestampTzExpression
    Focus::TimestampTzLiteral.new(value)
  end

  def null : Focus::NullLiteral
    Focus::NullLiteral.new
  end
end
