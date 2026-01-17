module Focus::Dsl::MathFunctions
  # abs - Absolute value
  def abs(expr : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    Focus::FloatExpression(T).new_float_func("ABS", expr)
  end

  def abs(expr : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    Focus::IntExpression(T).new_int_func("ABS", expr)
  end

  def ceil(expr : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    Focus::FloatExpression(T).new_float_func("CEIL", expr)
  end

  def floor(expr : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    Focus::FloatExpression(T).new_float_func("FLOOR", expr)
  end

  def round(expr : Focus::FloatExpression(T), precision : Focus::IntExpression(I)? = nil) : Focus::FloatExpression(T) forall T, I
    func = Focus::FunctionExpression.new("ROUND", [expr.as(Focus::Expression), precision.as(Focus::Expression?)].compact)
    Focus::FloatExpression(T).new(func)
  end

  def trunc(expr : Focus::FloatExpression(T), precision : Focus::IntExpression(I)? = nil) : Focus::FloatExpression(T) forall T, I
    func = Focus::FunctionExpression.new("TRUNC", [expr.as(Focus::Expression), precision.as(Focus::Expression?)].compact)
    Focus::FloatExpression(T).new(func)
  end

  def pow(base : Focus::NumericExpression, exponent : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("POW", base, exponent)
  end

  def power(base : Focus::NumericExpression, exponent : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("POWER", base, exponent)
  end

  def sqrt(expr : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("SQRT", expr)
  end

  def ln(expr : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("LN", expr)
  end

  def log(expr : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("LOG", expr)
  end

  # log(base, x) - Logarithm with specified base (always returns float)
  def log(base : Focus::NumericExpression, x : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    Focus::FloatExpression(Float64).new_float_func("LOG", base, x)
  end

  # sign - Sign of number (-1, 0, +1)
  def sign(expr : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    Focus::FloatExpression(T).new_float_func("SIGN", expr)
  end

  def sign(expr : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    Focus::IntExpression(T).new_int_func("SIGN", expr)
  end

  # pi - Pi constant (always returns float)
  def pi : Focus::FloatExpression(Float64)
    func = Focus::FunctionExpression.new("PI", [] of Focus::Expression)
    Focus::FloatExpression(Float64).new(func)
  end
end
