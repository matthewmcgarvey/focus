class Focus::ArrayExpression(T) < Focus::Expression
  def self.new_array_func(func_name, *expressions : Focus::Expression) : Focus::ArrayExpression(T)
    func = Focus::FunctionExpression.new(func_name, expressions.to_a(&.as(Focus::Expression)))
    Focus::ArrayExpression(T).new(func)
  end

  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  def less_than(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _less_than(rhs)
  end

  def less_than_eq(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _less_than_eq(rhs)
  end

  def greater_than(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _greater_than(rhs)
  end

  def greater_than_eq(rhs : Focus::ArrayExpression(T)) : Focus::BoolExpression
    _greater_than_eq(rhs)
  end

  def contains(rhs : Focus::ArrayExpression(T)) : BoolExpression
    binary_op("@>", rhs)
  end

  def is_contained_by(rhs : Focus::ArrayExpression(T)) : BoolExpression
    binary_op("<@", rhs)
  end

  def overlap(rhs : Focus::ArrayExpression(T)) : BoolExpression
    binary_op("&&", rhs)
  end

  def concat(rhs : Focus::ArrayExpression(T)) : Focus::ArrayExpression(T)
    expression = Focus::BinaryExpression.new(left: self, right: rhs, operator: "||")
    Focus::ArrayExpression(T).new(expression)
  end

  def array_append(rhs : T) : Focus::ArrayExpression(T)
    Focus::ArrayExpression(T).new_array_func("ARRAY_APPEND", self, rhs)
  end

  def at(at : IntExpression(Int32)) : T
    raise "TODO"
  end
end
