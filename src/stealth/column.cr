require "./column_declaring"
require "./dsl/operators"

class Stealth::Column(T)
  include Stealth::BaseColumn
  include Stealth::ColumnDeclaring(T)
  include Stealth::Dsl::Operators(T)

  def initialize(@table : Stealth::Table, @name : String, @sql_type : T.class)
  end

  def as_expression : Stealth::ColumnExpression(T)
    Stealth::ColumnExpression.new(table.as_expression, name, sql_type)
  end

  def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
    Stealth::ArgumentExpression.new(argument, sql_type)
  end
end
