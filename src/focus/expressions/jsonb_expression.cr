class Focus::JsonbExpression < Focus::Expression
  getter inner : Focus::Expression?

  def initialize(@inner : Focus::Expression? = nil)
  end

  def eq(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    _eq(rhs)
  end

  def not_eq(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    _not_eq(rhs)
  end

  def is_distinct_from(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    _is_distinct_from(rhs)
  end

  def is_not_distinct_from(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    _is_not_distinct_from(rhs)
  end

  # PostgreSQL JSONB containment operator @>
  def contains(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    binary_op("@>", rhs)
  end

  # PostgreSQL JSONB containment operator <@
  def contained_by(rhs : Focus::JsonbExpression) : Focus::BoolExpression
    binary_op("<@", rhs)
  end

  # PostgreSQL JSONB key existence operator ?
  def has_key(key : Focus::StringExpression) : Focus::BoolExpression
    binary_op("?", key)
  end

  # PostgreSQL JSONB any key existence operator ?|
  def has_any_key(keys : Focus::Expression) : Focus::BoolExpression
    binary_op("?|", keys)
  end

  # PostgreSQL JSONB all keys existence operator ?&
  def has_all_keys(keys : Focus::Expression) : Focus::BoolExpression
    binary_op("?&", keys)
  end

  # PostgreSQL JSONB path operator ->
  def get(key : Focus::StringExpression) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: key, operator: "->"))
  end

  # PostgreSQL JSONB path operator -> with integer index
  def get(index : Focus::IntExpression(Int32)) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: index, operator: "->"))
  end

  # PostgreSQL JSONB path operator ->> returns text
  def get_text(key : Focus::StringExpression) : Focus::StringExpression
    Focus::StringExpression.new(Focus::BinaryExpression.new(left: self, right: key, operator: "->>"))
  end

  # PostgreSQL JSONB path operator ->> with integer index returns text
  def get_text(index : Focus::IntExpression(Int32)) : Focus::StringExpression
    Focus::StringExpression.new(Focus::BinaryExpression.new(left: self, right: index, operator: "->>"))
  end

  # PostgreSQL JSONB path operator #>
  def get_path(path : Focus::Expression) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: path, operator: "#>"))
  end

  # PostgreSQL JSONB path operator #>> returns text
  def get_path_text(path : Focus::Expression) : Focus::StringExpression
    Focus::StringExpression.new(Focus::BinaryExpression.new(left: self, right: path, operator: "#>>"))
  end

  # PostgreSQL JSONB concatenation operator ||
  def concat(rhs : Focus::JsonbExpression) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: rhs, operator: "||"))
  end

  # PostgreSQL JSONB delete key operator -
  def delete(key : Focus::StringExpression) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: key, operator: "-"))
  end

  # PostgreSQL JSONB delete index operator -
  def delete(index : Focus::IntExpression(Int32)) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: index, operator: "-"))
  end

  # PostgreSQL JSONB delete path operator #-
  def delete_path(path : Focus::Expression) : Focus::JsonbExpression
    Focus::JsonbExpression.new(Focus::BinaryExpression.new(left: self, right: path, operator: "#-"))
  end
end
