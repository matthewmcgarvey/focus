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

  def coalesce(first : Focus::TimeExpression, *rest : Focus::TimeExpression) : Focus::TimeExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("COALESCE", args)
    Focus::TimeExpression.new(func)
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

  def nullif(first : Focus::TimeExpression, second : Focus::TimeExpression) : Focus::TimeExpression
    func = Focus::FunctionExpression.new("NULLIF", [first.as(Focus::Expression), second.as(Focus::Expression)])
    Focus::TimeExpression.new(func)
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

  def greatest(first : Focus::TimeExpression, *rest : Focus::TimeExpression) : Focus::TimeExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("GREATEST", args)
    Focus::TimeExpression.new(func)
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

  def least(first : Focus::TimeExpression, *rest : Focus::TimeExpression) : Focus::TimeExpression
    args = [first.as(Focus::Expression)] + rest.to_a.map(&.as(Focus::Expression))
    func = Focus::FunctionExpression.new("LEAST", args)
    Focus::TimeExpression.new(func)
  end

  def least(first : Focus::Expression, *rest : Focus::Expression) : Focus::Expression
    args = [first] + rest.to_a.map(&.as(Focus::Expression))
    Focus::FunctionExpression.new("LEAST", args)
  end
end
