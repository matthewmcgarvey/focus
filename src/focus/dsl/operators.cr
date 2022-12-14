module Focus::Dsl::Operators(T)
  def eq(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      Focus::BinaryExpressionType::EQUAL,
      left: as_expression,
      right: expr.as_expression
    )
  end

  def eq(val : T) : Focus::BinaryExpression(Bool, T)
    eq(wrap_argument(val))
  end

  def ==(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    eq(expr)
  end

  def ==(val : T) : Focus::BinaryExpression(Bool, T)
    eq(wrap_argument(val))
  end

  def not_eq(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      Focus::BinaryExpressionType::NOT_EQUAL,
      left: as_expression,
      right: expr.as_expression
    )
  end

  def not_eq(val : T) : Focus::BinaryExpression(Bool, T)
    not_eq(wrap_argument(val))
  end

  def !=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    not_eq(expr)
  end

  def !=(val : T) : Focus::BinaryExpression(Bool, T)
    not_eq(wrap_argument(val))
  end

  def between(range : Range(T, T)) : BetweenExpression(T)
    BetweenExpression(T).new(as_expression, wrap_argument(range.begin), wrap_argument(range.end))
  end

  def not_between(range : Range(T, T)) : BetweenExpression(T)
    BetweenExpression(T).new(as_expression, wrap_argument(range.begin), wrap_argument(range.end), not_between: true)
  end

  def in_list(*list : T) : InListExpression(T)
    in_list(list.to_a)
  end

  def in_list(list : Array(T)) : InListExpression(T)
    values = list.map { |value| wrap_argument(value) }
    InListExpression(T).new(left: as_expression, values: values)
  end

  def in_list(query : Query) : InListExpression(T)
    InListExpression(T).new(left: as_expression, query: query.expression)
  end

  def not_in_list(*list : T) : InListExpression(T)
    values = list.map { |value| wrap_argument(value) }.to_a
    InListExpression(T).new(left: as_expression, values: values, not_in_list: true)
  end

  def not_in_list(list : Array(T)) : InListExpression(T)
    values = list.map { |value| wrap_argument(value) }
    InListExpression(T).new(left: as_expression, values: values, not_in_list: true)
  end

  def not_in_list(query : Query) : InListExpression(T)
    InListExpression(T).new(left: as_expression, query: query.expression, not_in_list: true)
  end

  def is_null : UnaryExpression(Bool)
    UnaryExpression(Bool).new(
      Focus::UnaryExpressionType::IS_NULL,
      operand: as_expression
    )
  end

  def is_not_null : UnaryExpression(Bool)
    UnaryExpression(Bool).new(
      Focus::UnaryExpressionType::IS_NOT_NULL,
      operand: as_expression
    )
  end

  def unary_minus : UnaryExpression(T)
    UnaryExpression(T).new(
      Focus::UnaryExpressionType::UNARY_MINUS,
      operand: as_expression
    )
  end

  def unary_plus : UnaryExpression(T)
    UnaryExpression(T).new(
      Focus::UnaryExpressionType::UNARY_PLUS,
      operand: as_expression
    )
  end

  def not : UnaryExpression(Bool)
    UnaryExpression(Bool).new(
      Focus::UnaryExpressionType::NOT,
      operand: as_expression
    )
  end

  def plus(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    Focus::BinaryExpression(T, T).new(
      BinaryExpressionType::PLUS,
      as_expression,
      expr.as_expression
    )
  end

  def plus(value : T) : Focus::BinaryExpression(T, T)
    plus(wrap_argument(value))
  end

  def +(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    plus(expr)
  end

  def +(value : T) : Focus::BinaryExpression(T, T)
    plus(wrap_argument(value))
  end

  def minus(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    Focus::BinaryExpression(T, T).new(
      BinaryExpressionType::MINUS,
      as_expression,
      expr.as_expression
    )
  end

  def minus(value : T) : Focus::BinaryExpression(T, T)
    minus(wrap_argument(value))
  end

  def -(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    minus(expr)
  end

  def -(value : T) : Focus::BinaryExpression(T, T)
    minus(wrap_argument(value))
  end

  def times(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    Focus::BinaryExpression(T, T).new(
      BinaryExpressionType::TIMES,
      as_expression,
      expr.as_expression
    )
  end

  def times(value : T) : Focus::BinaryExpression(T, T)
    times(wrap_argument(value))
  end

  def *(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    times(expr)
  end

  def *(value : T) : Focus::BinaryExpression(T, T)
    times(wrap_argument(value))
  end

  def div(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    Focus::BinaryExpression(T, T).new(
      BinaryExpressionType::DIV,
      as_expression,
      expr.as_expression
    )
  end

  def div(value : T) : Focus::BinaryExpression(T, T)
    div(wrap_argument(value))
  end

  def /(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    div(expr)
  end

  def /(value : T) : Focus::BinaryExpression(T, T)
    div(wrap_argument(value))
  end

  def rem(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    Focus::BinaryExpression(T, T).new(
      BinaryExpressionType::REM,
      as_expression,
      expr.as_expression
    )
  end

  def rem(value : T) : Focus::BinaryExpression(T, T)
    rem(wrap_argument(value))
  end

  def %(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T, T)
    rem(expr)
  end

  def %(value : T) : Focus::BinaryExpression(T, T)
    rem(wrap_argument(value))
  end

  def like(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::LIKE,
      as_expression,
      expr.as_expression
    )
  end

  def like(value : T) : Focus::BinaryExpression(Bool, T)
    like(wrap_argument(value))
  end

  def not_like(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::NOT_LIKE,
      as_expression,
      expr.as_expression
    )
  end

  def not_like(value : T) : Focus::BinaryExpression(Bool, T)
    not_like(wrap_argument(value))
  end

  def and(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::AND,
      as_expression,
      expr.as_expression
    )
  end

  def and(value : T) : Focus::BinaryExpression(Bool, T)
    and(wrap_argument(value))
  end

  def &(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    and(expr)
  end

  def &(value : T) : Focus::BinaryExpression(Bool, T)
    and(wrap_argument(value))
  end

  def or(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::OR,
      as_expression,
      expr.as_expression
    )
  end

  def or(value : T) : Focus::BinaryExpression(Bool, T)
    or(wrap_argument(value))
  end

  def |(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    or(expr)
  end

  def |(value : T) : Focus::BinaryExpression(Bool, T)
    or(wrap_argument(value))
  end

  def xor(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::XOR,
      as_expression,
      expr.as_expression
    )
  end

  def xor(value : T) : Focus::BinaryExpression(Bool, T)
    xor(wrap_argument(value))
  end

  def ^(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    xor(expr)
  end

  def ^(value : T) : Focus::BinaryExpression(Bool, T)
    xor(wrap_argument(value))
  end

  def less_than(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::LESS_THAN,
      as_expression,
      expr.as_expression
    )
  end

  def less_than(value : T) : Focus::BinaryExpression(Bool, T)
    less_than(wrap_argument(value))
  end

  def <(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    less_than(expr)
  end

  def <(value : T) : Focus::BinaryExpression(Bool, T)
    less_than(wrap_argument(value))
  end

  def greater_than(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::GREATER_THAN,
      as_expression,
      expr.as_expression
    )
  end

  def greater_than(value : T) : Focus::BinaryExpression(Bool, T)
    greater_than(wrap_argument(value))
  end

  def >(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    greater_than(expr)
  end

  def >(value : T) : Focus::BinaryExpression(Bool, T)
    greater_than(wrap_argument(value))
  end

  def less_than_or_equal(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::LESS_THAN_OR_EQUAL,
      as_expression,
      expr.as_expression
    )
  end

  def less_than_or_equal(value : T) : Focus::BinaryExpression(Bool, T)
    less_than_or_equal(wrap_argument(value))
  end

  def <=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    less_than_or_equal(expr)
  end

  def <=(value : T) : Focus::BinaryExpression(Bool, T)
    less_than_or_equal(wrap_argument(value))
  end

  def greater_than_or_equal(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    Focus::BinaryExpression(Bool, T).new(
      BinaryExpressionType::GREATER_THAN_OR_EQUAL,
      as_expression,
      expr.as_expression
    )
  end

  def greater_than_or_equal(value : T) : Focus::BinaryExpression(Bool, T)
    greater_than_or_equal(wrap_argument(value))
  end

  def >=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool, T)
    greater_than_or_equal(expr)
  end

  def >=(value : T) : Focus::BinaryExpression(Bool, T)
    greater_than_or_equal(wrap_argument(value))
  end
end

module Focus::Dsl::TopLevelOperators
  def exists(query : Query) : ExistsExpression
    ExistsExpression.new(query.expression)
  end

  def not_exists(query : Query) : ExistsExpression
    ExistsExpression.new(query.expression, not_exists: true)
  end
end
