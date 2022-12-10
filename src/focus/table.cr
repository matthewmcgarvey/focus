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

  def as_expression : Focus::TableExpression
    Focus::TableExpression.new(name: table_name)
  end
end
