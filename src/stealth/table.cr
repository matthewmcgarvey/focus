abstract class Stealth::Table
  annotation ColumnLabel
  end

  macro define(klass, table_name)
    class {{ klass }}_Table < Stealth::Table

      {{ yield }}

      @table_name = {{ table_name }}
    end

    {{ klass }} = {{ klass }}_Table.new
  end

  private macro column(type_declaration)
    {%
      name = type_declaration.var
      name_str = name.stringify
      type = type_declaration.type
    %}

    @[ColumnLabel]
    getter {{ name }} : Stealth::Column({{ type }}) do
      Stealth::Column.new(table: self, name: {{ name_str }}, sql_type: {{ type }})
    end
  end

  getter table_name : String
  getter columns : Array(Stealth::BaseColumn) = [] of Stealth::BaseColumn

  def initialize
    {% begin %}
      {% for ivar in @type.instance_vars %}
        {% ann = ivar.annotation(::Stealth::Table::ColumnLabel) %}
        {% if ann %}
          columns << {{ ivar.id }}
        {% end %}
      {% end %}
    {% end %}
  end

  def as_expression : Stealth::TableExpression
    Stealth::TableExpression.new(name: table_name)
  end
end
