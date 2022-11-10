module Stealth::Table
  macro define(klass, table_name)
    class {{ klass }}
      COLUMNS = [] of Stealth::BaseColumn
      {% verbatim do %}
      private macro column(type_declaration)
        {%
          name = type_declaration.var
          name_str = name.stringify
          type = type_declaration.type
        %}
        COLUMNS << {{ name }}
        class_getter {{ name }} : Stealth::Column({{ type }}) do
          Stealth::Column.new(table: self, name: {{ name_str }}, sql_type: {{ type }})
        end
      end
      {% end %}

      extend Stealth::Table

      {{ yield }}

      class_getter table_name : String = {{ table_name }}
      class_getter columns : Array(Stealth::BaseColumn) = COLUMNS
    end
  end

  abstract def table_name : String
  abstract def columns : Array(Stealth::BaseColumn)

  def as_expression : Stealth::TableExpression
    Stealth::TableExpression.new(name: table_name)
  end
end
