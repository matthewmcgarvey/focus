require "./column_declaring"

module Focus::BaseColumn
  include Focus::BaseColumnDeclaring

  getter table : Focus::Table
  getter name : String

  abstract def as_expression : Focus::BaseColumnExpression

  def label : String
    name
  end
end

class Focus::Column(T)
  include Focus::BaseColumn
  include Focus::ColumnDeclaring(T)

  def initialize(@table : Focus::Table, @name : String, @sql_type : T.class)
  end

  def as_expression : Focus::ColumnExpression(T)
    Focus::ColumnExpression.new(table.as_expression, name, sql_type)
  end

  def wrap_argument(argument : T) : Focus::ArgumentExpression(T)
    Focus::ArgumentExpression.new(argument, sql_type)
  end

  def aliased(label : String? = nil) : Focus::ColumnDeclaringExpression(T)
    Focus::ColumnDeclaringExpression.new(as_expression, label)
  end

  def as_declaring_expression : Focus::ColumnDeclaringExpression(T)
    aliased(label)
  end
end
