module Focus::Dsl::Operators(T)
  def eq(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      Focus::BinaryExpressionType::EQUAL,
      left: as_expression,
      right: expr.as_expression,
      sql_type: Bool
    )
  end

  def eq(val : T) : Focus::BinaryExpression(Bool)
    eq(wrap_argument(val))
  end

  def ==(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    eq(expr)
  end

  def ==(val : T) : Focus::BinaryExpression(Bool)
    eq(wrap_argument(val))
  end

  def not_eq(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      Focus::BinaryExpressionType::NOT_EQUAL,
      left: as_expression,
      right: expr.as_expression,
      sql_type: Bool
    )
  end

  def not_eq(val : T) : Focus::BinaryExpression(Bool)
    not_eq(wrap_argument(val))
  end

  def !=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    not_eq(expr)
  end

  def !=(val : T) : Focus::BinaryExpression(Bool)
    not_eq(wrap_argument(val))
  end

  def between(range : Range(T, T)) : BetweenExpression(T)
    BetweenExpression.new(as_expression, wrap_argument(range.begin), wrap_argument(range.end))
  end

  def not_between(range : Range(T, T)) : BetweenExpression(T)
    BetweenExpression.new(as_expression, wrap_argument(range.begin), wrap_argument(range.end), not_between: true)
  end

  def in_list(*list : T) : InListExpression(T)
    values = list.map { |value| wrap_argument(value).as(Focus::ScalarExpression(T)) }.to_a
    InListExpression.new(left: as_expression, values: values)
  end

  def in_list(list : Array(T)) : InListExpression(T)
    values = list.map { |value| wrap_argument(value).as(Focus::ScalarExpression(T)) }
    InListExpression.new(left: as_expression, values: values)
  end

  def in_list(query : Query) : InListExpression(T)
    InListExpression.new(left: as_expression, query: query.expression)
  end

  def not_in_list(*list : T) : InListExpression(T)
    values = list.map { |value| wrap_argument(value).as(Focus::ScalarExpression(T)) }.to_a
    InListExpression.new(left: as_expression, values: values, not_in_list: true)
  end

  def not_in_list(list : Array(T)) : InListExpression(T)
    values = list.map { |value| wrap_argument(value) }
    InListExpression.new(left: as_expression, values: values, not_in_list: true)
  end

  def not_in_list(query : Query) : InListExpression(T)
    InListExpression.new(left: as_expression, query: query.expression, not_in_list: true)
  end

  def is_null : UnaryExpression(Bool)
    UnaryExpression.new(
      Focus::UnaryExpressionType::IS_NULL,
      operand: as_expression,
      sql_type: Bool
    )
  end

  def is_not_null : UnaryExpression(Bool)
    UnaryExpression.new(
      Focus::UnaryExpressionType::IS_NOT_NULL,
      operand: as_expression,
      sql_type: Bool
    )
  end

  def unary_minus : UnaryExpression(T)
    UnaryExpression.new(
      Focus::UnaryExpressionType::UNARY_MINUS,
      operand: as_expression,
      sql_type: sql_type
    )
  end

  def unary_plus : UnaryExpression(T)
    UnaryExpression.new(
      Focus::UnaryExpressionType::UNARY_PLUS,
      operand: as_expression,
      sql_type: sql_type
    )
  end

  def not : UnaryExpression(Bool)
    UnaryExpression.new(
      Focus::UnaryExpressionType::NOT,
      operand: as_expression,
      sql_type: Bool
    )
  end

  def plus(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    Focus::BinaryExpression.new(
      BinaryExpressionType::PLUS,
      as_expression,
      expr.as_expression,
      sql_type
    )
  end

  def plus(value : T) : Focus::BinaryExpression(T)
    plus(wrap_argument(value))
  end

  def +(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    plus(expr)
  end

  def +(value : T) : Focus::BinaryExpression(T)
    plus(wrap_argument(value))
  end

  def minus(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    Focus::BinaryExpression.new(
      BinaryExpressionType::MINUS,
      as_expression,
      expr.as_expression,
      sql_type
    )
  end

  def minus(value : T) : Focus::BinaryExpression(T)
    minus(wrap_argument(value))
  end

  def -(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    minus(expr)
  end

  def -(value : T) : Focus::BinaryExpression(T)
    minus(wrap_argument(value))
  end

  def times(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    Focus::BinaryExpression.new(
      BinaryExpressionType::TIMES,
      as_expression,
      expr.as_expression,
      sql_type
    )
  end

  def times(value : T) : Focus::BinaryExpression(T)
    times(wrap_argument(value))
  end

  def *(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    times(expr)
  end

  def *(value : T) : Focus::BinaryExpression(T)
    times(wrap_argument(value))
  end

  def div(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    Focus::BinaryExpression.new(
      BinaryExpressionType::DIV,
      as_expression,
      expr.as_expression,
      sql_type
    )
  end

  def div(value : T) : Focus::BinaryExpression(T)
    div(wrap_argument(value))
  end

  def /(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    div(expr)
  end

  def /(value : T) : Focus::BinaryExpression(T)
    div(wrap_argument(value))
  end

  def rem(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    Focus::BinaryExpression.new(
      BinaryExpressionType::REM,
      as_expression,
      expr.as_expression,
      sql_type
    )
  end

  def rem(value : T) : Focus::BinaryExpression(T)
    rem(wrap_argument(value))
  end

  def %(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(T)
    rem(expr)
  end

  def %(value : T) : Focus::BinaryExpression(T)
    rem(wrap_argument(value))
  end

  def like(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(B)
    Focus::BinaryExpression.new(
      BinaryExpressionType::LIKE,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def like(value : T) : Focus::BinaryExpression(Bool)
    like(wrap_argument(value))
  end

  def not_like(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::NOT_LIKE,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def not_like(value : T) : Focus::BinaryExpression(Bool)
    not_like(wrap_argument(value))
  end

  def and(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::AND,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def and(value : T) : Focus::BinaryExpression(Bool)
    and(wrap_argument(value))
  end

  def &(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    and(expr)
  end

  def &(value : T) : Focus::BinaryExpression(Bool)
    and(wrap_argument(value))
  end

  def or(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::OR,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def or(value : T) : Focus::BinaryExpression(Bool)
    or(wrap_argument(value))
  end

  def |(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    or(expr)
  end

  def |(value : T) : Focus::BinaryExpression(Bool)
    or(wrap_argument(value))
  end

  def xor(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::XOR,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def xor(value : T) : Focus::BinaryExpression(Bool)
    xor(wrap_argument(value))
  end

  def ^(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    xor(expr)
  end

  def ^(value : T) : Focus::BinaryExpression(Bool)
    xor(wrap_argument(value))
  end

  def less_than(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::LESS_THAN,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def less_than(value : T) : Focus::BinaryExpression(Bool)
    less_than(wrap_argument(value))
  end

  def <(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    less_than(expr)
  end

  def <(value : T) : Focus::BinaryExpression(Bool)
    less_than(wrap_argument(value))
  end

  def greater_than(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::GREATER_THAN,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def greater_than(value : T) : Focus::BinaryExpression(Bool)
    greater_than(wrap_argument(value))
  end

  def >(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    greater_than(expr)
  end

  def >(value : T) : Focus::BinaryExpression(Bool)
    greater_than(wrap_argument(value))
  end

  def less_than_or_equal(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::LESS_THAN_OR_EQUAL,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def less_than_or_equal(value : T) : Focus::BinaryExpression(Bool)
    less_than_or_equal(wrap_argument(value))
  end

  def <=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    less_than_or_equal(expr)
  end

  def <=(value : T) : Focus::BinaryExpression(Bool)
    less_than_or_equal(wrap_argument(value))
  end

  def greater_than_or_equal(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    Focus::BinaryExpression.new(
      BinaryExpressionType::GREATER_THAN_OR_EQUAL,
      as_expression,
      expr.as_expression,
      Bool
    )
  end

  def greater_than_or_equal(value : T) : Focus::BinaryExpression(Bool)
    greater_than_or_equal(wrap_argument(value))
  end

  def >=(expr : ColumnDeclaring(T)) : Focus::BinaryExpression(Bool)
    greater_than_or_equal(expr)
  end

  def >=(value : T) : Focus::BinaryExpression(Bool)
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
