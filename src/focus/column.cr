require "./column_declaring"

module Focus::BaseColumn
  include Focus::BaseColumnDeclaring

  getter table_name : String?
  getter name : String

  abstract def as_expression : Focus::BaseColumnExpression

  def label : String
    name
  end
end

class Focus::Column(T)
  include Focus::BaseColumn
  include Focus::ColumnDeclaring(T)

  def initialize(@name : String, @table_name : String? = nil)
  end

  def as_expression : Focus::ColumnExpression(T)
    Focus::ColumnExpression(T).new(name, table_name)
  end

  def wrap_argument(argument : T?) : Focus::ArgumentExpression(T)
    Focus::ArgumentExpression(T).new(argument)
  end

  def aliased(label : String? = nil) : Focus::ColumnDeclaringExpression(T)
    Focus::ColumnDeclaringExpression(T).new(as_expression, label)
  end

  def as_declaring_expression : Focus::ColumnDeclaringExpression(T)
    aliased(label)
  end

  def from(table : Focus::Table) : Focus::Column(T)
    Focus::Column(T).new(name, table.table_name)
  end
end
