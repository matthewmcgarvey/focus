module Stealth::BaseScalarExpression
  include Stealth::SqlExpression
end

module Stealth::ScalarExpression(T)
  include Stealth::BaseScalarExpression
  include Stealth::ColumnDeclaring(T)

  def as_expression : Stealth::ScalarExpression(T)
    self
  end

  def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
    ArgumentExpression.new(argument, sql_type)
  end

  def aliased(label : String? = nil) : Stealth::ColumnDeclaringExpression(T)
    Stealth::ColumnDeclaringExpression.new(self, label)
  end

  def as_declaring_expression : Stealth::ColumnDeclaringExpression(T)
    aliased(nil)
  end
end

module Stealth::QuerySourceExpression
  include Stealth::SqlExpression
end

module Stealth::QueryExpression
  include Stealth::QuerySourceExpression

  getter table_alias : String?
end

class Stealth::TableExpression
  include Stealth::QuerySourceExpression

  getter name : String
  getter table_alias : String?
  getter catalog : String?
  getter schema : String?

  def initialize(@name, @table_alias = nil, @catalog = nil, @schema = nil)
  end

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::SelectExpression
  include Stealth::QueryExpression

  getter columns : Array(BaseColumnDeclaringExpression)
  getter from : QuerySourceExpression
  getter where : ScalarExpression(Bool)?
  getter group_by : Array(BaseScalarExpression)
  getter having : ScalarExpression(Bool)?
  getter order_by : Array(OrderByExpression)
  getter is_distinct : Bool
  getter limit : Int32?
  getter offset : Int32?

  def initialize(
    @from,
    @columns = [] of BaseColumnDeclaringExpression,
    @where = nil,
    @group_by = [] of BaseScalarExpression,
    @having = nil,
    @order_by = [] of OrderByExpression,
    @is_distinct = false,
    @limit = nil,
    @offset = nil
  )
  end

  def copy(
    columns = self.columns,
    from = self.from,
    where = self.where,
    group_by = self.group_by,
    having = self.having,
    order_by = self.order_by,
    is_distinct = self.is_distinct,
    limit = self.limit,
    offset = self.offset
  )
    SelectExpression.new(
      from,
      columns,
      where,
      group_by,
      having,
      order_by,
      is_distinct,
      limit,
      offset
    )
  end
end

class Stealth::AggregateExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::AggregateType
  getter argument : Stealth::BaseScalarExpression?
  getter is_distinct : Bool

  def initialize(@type, @argument, @is_distinct, @sql_type)
  end

  def method : String
    type.method
  end

  def wrap_in_parens? : Bool
    false
  end
end

enum Stealth::AggregateType
  MIN
  MAX
  AVG
  SUM
  COUNT

  def method : String
    case self
    when MIN
      "min"
    when MAX
      "max"
    when AVG
      "avg"
    when SUM
      "sum"
    when COUNT
      "count"
    else
      raise "missing a case statement for #{self}"
    end
  end
end

module Stealth::BaseArgumentExpression
  abstract def value
end

class Stealth::ArgumentExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseArgumentExpression

  getter value : T

  def initialize(@value, @sql_type)
  end
end

class Stealth::BetweenExpression(T)
  include Stealth::ScalarExpression(Bool)

  getter expression : Stealth::ScalarExpression(T)
  getter lower : Stealth::ScalarExpression(T)
  getter upper : Stealth::ScalarExpression(T)
  getter not_between : Bool

  def initialize(@expression, @lower, @upper, @not_between = false)
    @sql_type = Bool
  end

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::BinaryExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::BinaryExpressionType
  getter left : Stealth::BaseScalarExpression
  getter right : Stealth::BaseScalarExpression

  def initialize(@type, @left, @right, @sql_type)
  end

  def operator : String
    type.operator
  end
end

enum Stealth::BinaryExpressionType
  PLUS
  MINUS
  TIMES
  DIV
  REM
  LIKE
  NOT_LIKE
  AND
  OR
  XOR
  LESS_THAN
  LESS_THAN_OR_EQUAL
  GREATER_THAN
  GREATER_THAN_OR_EQUAL
  EQUAL
  NOT_EQUAL

  def operator : String
    case self
    when PLUS
      "+"
    when MINUS
      "-"
    when TIMES
      "*"
    when DIV
      "/"
    when REM
      "%"
    when LIKE
      "like"
    when NOT_LIKE
      "not like"
    when AND
      "and"
    when OR
      "or"
    when XOR
      "xor"
    when LESS_THAN
      "<"
    when LESS_THAN_OR_EQUAL
      "<="
    when GREATER_THAN
      ">"
    when GREATER_THAN_OR_EQUAL
      ">="
    when EQUAL
      "="
    when NOT_EQUAL
      "<>"
    else
      raise "missing a case statement for #{self}"
    end
  end
end

module Stealth::BaseColumnExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression?
  getter name : String

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::ColumnExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseColumnExpression

  def initialize(@table, @name, @sql_type)
  end

  def initialize(@name, @sql_type)
    @table = nil
  end
end

module Stealth::BaseColumnDeclaringExpression
  include Stealth::SqlExpression

  getter declared_name : String?

  def wrap_in_parens? : Bool
    false
  end
end

class Stealth::ColumnDeclaringExpression(T)
  include Stealth::ScalarExpression(T)
  include Stealth::BaseColumnDeclaringExpression

  getter expression : ScalarExpression(T)

  def initialize(@expression, @declared_name, @sql_type = expression.sql_type)
  end
end

module Stealth::BaseColumnAssignmentExpression
  include Stealth::SqlExpression

  abstract def column : Stealth::BaseColumnExpression
  abstract def expression : Stealth::BaseScalarExpression
end

class Stealth::ColumnAssignmentExpression(T)
  include Stealth::BaseColumnAssignmentExpression

  getter column : Stealth::ColumnExpression(T)
  getter expression : Stealth::ScalarExpression(T)

  def initialize(@column, @expression)
  end
end

class Stealth::DeleteExpression
  include Stealth::SqlExpression
  getter table : TableExpression
  getter where : ScalarExpression(Bool)?

  def initialize(@table, @where)
  end
end

class Stealth::ExistsExpression
  include Stealth::ScalarExpression(Bool)

  getter query : QueryExpression
  getter not_exists : Bool

  def initialize(@query, @not_exists = false)
    @sql_type = Bool
  end
end

class Stealth::InListExpression(T)
  include Stealth::ScalarExpression(Bool)

  getter left : ScalarExpression(T)
  getter query : QueryExpression?
  getter values : Array(ScalarExpression(T))?
  getter not_in_list : Bool

  def initialize(@left, @query = nil, @values = nil, @not_in_list = false)
    @sql_type = Bool
  end
end

class Stealth::InsertExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter assignments : Array(BaseColumnAssignmentExpression)

  def initialize(@table, @assignments)
  end
end

class Stealth::JoinExpression
  include Stealth::QuerySourceExpression

  getter type : JoinType
  getter left : QuerySourceExpression
  getter right : QuerySourceExpression
  getter condition : ScalarExpression(Bool)?

  def initialize(@type, @left, @right, @condition = nil)
  end

  def join_type : String
    type.join_type
  end
end

enum Stealth::JoinType
  CROSS_JOIN
  INNER_JOIN
  LEFT_JOIN
  RIGHT_JOIN

  def join_type : String
    case self
    when CROSS_JOIN
      "cross join"
    when INNER_JOIN
      "inner join"
    when LEFT_JOIN
      "left join"
    when RIGHT_JOIN
      "right join"
    else
      raise "missing a case statement for #{self}"
    end
  end
end

class Stealth::OrderByExpression
  include Stealth::SqlExpression

  getter expression : BaseScalarExpression
  getter order_type : OrderType

  def initialize(@expression, @order_type)
  end

  def order : String
    order_type.order
  end
end

enum Stealth::OrderType
  ASCENDING
  DESCENDING

  def order : String
    case self
    when ASCENDING
      "asc"
    when DESCENDING
      "desc"
    else
      raise "missing a case statement for #{self}"
    end
  end
end

class Stealth::UnaryExpression(T)
  include Stealth::ScalarExpression(T)

  getter type : Stealth::UnaryExpressionType
  getter operand : Stealth::BaseScalarExpression

  def initialize(@type, @operand, @sql_type)
  end

  def operator : String
    type.operator
  end
end

enum Stealth::UnaryExpressionType
  IS_NULL
  IS_NOT_NULL
  UNARY_MINUS
  UNARY_PLUS
  NOT

  def operator : String
    case self
    when IS_NULL
      "is null"
    when IS_NOT_NULL
      "is not null"
    when UNARY_MINUS
      "-"
    when UNARY_PLUS
      "+"
    when NOT
      "not"
    else
      raise "missing a case statement for #{self}"
    end
  end
end

class Stealth::UpdateExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter assignments : Array(Stealth::BaseColumnAssignmentExpression)
  getter where : Stealth::ScalarExpression(Bool)?

  def initialize(@table, @assignments, @where = nil)
  end
end
