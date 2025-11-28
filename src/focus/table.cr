abstract class Focus::Table
  annotation ColumnLabel
  end

  private macro column(type_declaration)
    {%
      name = type_declaration.var
      name_str = name.stringify
      type = type_declaration.type
    %}

    @[ColumnLabel]
    getter {{ name }} : Focus::Column({{ type }}) do
      Focus::Column({{ type }}).new(table: self, name: {{ name_str }})
    end
  end

  getter table_name : String
  getter columns : Array(Focus::BaseColumn) = [] of Focus::BaseColumn
  protected property label : String?

  def initialize
    {% begin %}
      {% for ivar in @type.instance_vars %}
        {% ann = ivar.annotation(::Focus::Table::ColumnLabel) %}
        {% if ann %}
          columns << {{ ivar.id }}
        {% end %}
      {% end %}
    {% end %}
  end

  def aliased(label : String? = nil) : self
    new_instance = self.class.new
    new_instance.label = label
    new_instance
  end

  def as_expression : Focus::TableExpression
    Focus::TableExpression.new(name: table_name, table_alias: label)
  end

  def column(name : String, type : T.class) : Focus::Column(T) forall T
    columns.select(Focus::Column(T)).find { |col| col.name == name } || raise "Column '#{name}' not found in table '#{table_name}'"
  end
end

class Focus::SubselectTable < Focus::Table
  getter subquery : Focus::SelectExpression

  def initialize(@subquery : Focus::SelectExpression)
  end

  def table_name : String
    subquery.table_alias.not_nil!("Subselect table must have an alias")
  end

  def column(name : String, type : T.class) : Focus::Column(T) forall T
    col_expression = subquery.columns.select(Focus::ColumnDeclaringExpression(T)).find { |col| col.declared_name == name } || raise "Column '#{name}' not found in subselect table '#{table_name}'"
    Focus::Column(T).new(self, col_expression.declared_name.not_nil!("Column must have a name"))
  end
end
