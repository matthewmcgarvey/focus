abstract class Focus::Table
  include Focus::Joinable

  annotation ColumnLabel
  end

  private macro column(type_declaration)
    {%
      name = type_declaration.var
      name_str = name.stringify
      type = type_declaration.type
    %}

    @[ColumnLabel]
    getter {{ name }} : Focus::{{ type }}Column do
      Focus::{{ type }}Column.new(table_name: self.label || self.table_name, name: {{ name_str }})
    end
  end

  getter table_name : String
  getter columns : Array(Focus::Column) = [] of Focus::Column
  protected property label : String?

  def initialize(@label = nil)
    {% begin %}
      {% for ivar in @type.instance_vars %}
        {% ann = ivar.annotation(::Focus::Table::ColumnLabel) %}
        {% if ann %}
          columns << {{ ivar.id }}
        {% end %}
      {% end %}
    {% end %}
  end

  def aliased(label : String? = nil) : Focus::Table
    self.class.new(label)
  end

  def insert(*columns : Focus::Column) : Focus::InsertStatement
    Focus.insert(self, *columns)
  end

  def update : Focus::UpdateStatement
    Focus.update(self)
  end

  def delete : Focus::DeleteStatement
    Focus.delete(self)
  end

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::SelectStatement
    projections = fields.map { |field| (field.is_a?(Focus::ProjectionExpression) ? field : Focus::ProjectionExpression.new(field)).as(Focus::ProjectionExpression) }
    Focus.select(*projections).from(self)
  end

  def select : Focus::SelectStatement
    Focus.select.from(self)
  end

  def as_table_source : Focus::TableSource
    Focus::TableReferenceExpression.new(table_name)
  end
end
