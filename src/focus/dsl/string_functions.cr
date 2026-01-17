module Focus::Dsl::StringFunctions
  def length(expr : Focus::StringExpression) : Focus::IntExpression(Int64)
    Focus::IntExpression(Int64).new_int_func("LENGTH", expr)
  end

  def lower(expr : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("LOWER", expr)
  end

  def upper(expr : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("UPPER", expr)
  end

  def ltrim(expr : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("LTRIM", expr)
  end

  def ltrim(expr : Focus::StringExpression, chars : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("LTRIM", expr, chars)
  end

  def rtrim(expr : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("RTRIM", expr)
  end

  def rtrim(expr : Focus::StringExpression, chars : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("RTRIM", expr, chars)
  end

  def trim(expr : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("TRIM", expr)
  end

  def trim(expr : Focus::StringExpression, chars : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("TRIM", expr, chars)
  end

  def substr(expr : Focus::StringExpression, start : Focus::IntExpression(I)) : Focus::StringExpression forall I
    Focus::StringExpression.new_string_func("SUBSTR", expr, start)
  end

  def substr(expr : Focus::StringExpression, start : Focus::IntExpression(I), len : Focus::IntExpression(L)) : Focus::StringExpression forall I, L
    Focus::StringExpression.new_string_func("SUBSTR", expr, start, len)
  end

  def replace(expr : Focus::StringExpression, from : Focus::StringExpression, to : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new_string_func("REPLACE", expr, from, to)
  end

  def concat(*exprs : Focus::Expression) : Focus::StringExpression
    func = Focus::FunctionExpression.new("CONCAT", exprs.to_a.map(&.as(Focus::Expression)))
    Focus::StringExpression.new(func)
  end

  def concat_ws(separator : Focus::StringExpression, *exprs : Focus::Expression) : Focus::StringExpression
    args = [separator.as(Focus::Expression)] + exprs.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("CONCAT_WS", args)
    Focus::StringExpression.new(func)
  end
end
