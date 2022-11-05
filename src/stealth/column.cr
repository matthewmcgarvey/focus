require "./column_declaring"

module Stealth::BaseColumn
  include Stealth::BaseColumnDeclaring

  getter table : Stealth::Table
  getter name : String

  abstract def as_expression : Stealth::BaseColumnExpression

  def label : String
    name
  end
end

class Stealth::Column(T)
  include Stealth::BaseColumn
  include Stealth::ColumnDeclaring(T)

  def initialize(@table : Stealth::Table, @name : String, @sql_type : T.class)
  end

  def as_expression : Stealth::ColumnExpression(T)
    Stealth::ColumnExpression.new(table.as_expression, name, sql_type)
  end

  def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
    Stealth::ArgumentExpression.new(argument, sql_type)
  end

  def aliased(label : String? = nil) : Stealth::ColumnDeclaringExpression(T)
    Stealth::ColumnDeclaringExpression.new(as_expression, label)
  end

  def as_declaring_expression : Stealth::ColumnDeclaringExpression(T)
    aliased(label)
  end
end
