module Focus::Dsl::ConditionalFunctions
  # coalesce - Returns first non-null value
  def coalesce(first : Focus::IntExpression(T), *rest : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::IntExpression(T).new(func)
  end

  def coalesce(first : Focus::FloatExpression(T), *rest : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::FloatExpression(T).new(func)
  end

  def coalesce(first : Focus::StringExpression, *rest : Focus::StringExpression) : Focus::StringExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::StringExpression.new(func)
  end

  def coalesce(first : Focus::BoolExpression, *rest : Focus::BoolExpression) : Focus::BoolExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::BoolExpression.new(func)
  end

  def coalesce(first : Focus::DateExpression, *rest : Focus::DateExpression) : Focus::DateExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::DateExpression.new(func)
  end

  def coalesce(first : Focus::TimestampExpression, *rest : Focus::TimestampExpression) : Focus::TimestampExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::TimestampExpression.new(func)
  end

  def coalesce(first : Focus::TimestampTzExpression, *rest : Focus::TimestampTzExpression) : Focus::TimestampTzExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::TimestampTzExpression.new(func)
  end

  def coalesce(first : Focus::Expression, *rest : Focus::Expression) : Focus::Expression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    Focus::FunctionExpression.new("COALESCE", args)
  end

  # nullif - Returns null if the two arguments are equal
  def nullif(first : Focus::IntExpression(T), second : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::IntExpression(T).new(func)
  end

  def nullif(first : Focus::FloatExpression(T), second : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::FloatExpression(T).new(func)
  end

  def nullif(first : Focus::StringExpression, second : Focus::StringExpression) : Focus::StringExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::StringExpression.new(func)
  end

  def nullif(first : Focus::BoolExpression, second : Focus::BoolExpression) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::BoolExpression.new(func)
  end

  def nullif(first : Focus::DateExpression, second : Focus::DateExpression) : Focus::DateExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::DateExpression.new(func)
  end

  def nullif(first : Focus::TimestampExpression, second : Focus::TimestampExpression) : Focus::TimestampExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::TimestampExpression.new(func)
  end

  def nullif(first : Focus::TimestampTzExpression, second : Focus::TimestampTzExpression) : Focus::TimestampTzExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::TimestampTzExpression.new(func)
  end

  def nullif(first : Focus::Expression, second : Focus::Expression) : Focus::Expression
    Focus::FunctionExpression.new("NULLIF", [first, second])
  end

  # greatest - Returns the largest value from a list of expressions
  def greatest(first : Focus::IntExpression(T), *rest : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::IntExpression(T).new(func)
  end

  def greatest(first : Focus::FloatExpression(T), *rest : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::FloatExpression(T).new(func)
  end

  def greatest(first : Focus::StringExpression, *rest : Focus::StringExpression) : Focus::StringExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::StringExpression.new(func)
  end

  def greatest(first : Focus::DateExpression, *rest : Focus::DateExpression) : Focus::DateExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::DateExpression.new(func)
  end

  def greatest(first : Focus::TimestampExpression, *rest : Focus::TimestampExpression) : Focus::TimestampExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::TimestampExpression.new(func)
  end

  def greatest(first : Focus::TimestampTzExpression, *rest : Focus::TimestampTzExpression) : Focus::TimestampTzExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::TimestampTzExpression.new(func)
  end

  def greatest(first : Focus::Expression, *rest : Focus::Expression) : Focus::Expression
    args = [first] + rest.to_a.map(&.as(Focus::Expression))
    Focus::FunctionExpression.new("GREATEST", args)
  end

  # least - Returns the smallest value from a list of expressions
  def least(first : Focus::IntExpression(T), *rest : Focus::IntExpression(T)) : Focus::IntExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::IntExpression(T).new(func)
  end

  def least(first : Focus::FloatExpression(T), *rest : Focus::FloatExpression(T)) : Focus::FloatExpression(T) forall T
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::FloatExpression(T).new(func)
  end

  def least(first : Focus::StringExpression, *rest : Focus::StringExpression) : Focus::StringExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::StringExpression.new(func)
  end

  def least(first : Focus::DateExpression, *rest : Focus::DateExpression) : Focus::DateExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::DateExpression.new(func)
  end

  def least(first : Focus::TimestampExpression, *rest : Focus::TimestampExpression) : Focus::TimestampExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::TimestampExpression.new(func)
  end

  def least(first : Focus::TimestampTzExpression, *rest : Focus::TimestampTzExpression) : Focus::TimestampTzExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::TimestampTzExpression.new(func)
  end

  def least(first : Focus::Expression, *rest : Focus::Expression) : Focus::Expression
    args = [first] + rest.to_a.map(&.as(Focus::Expression))
    Focus::FunctionExpression.new("LEAST", args)
  end
end
