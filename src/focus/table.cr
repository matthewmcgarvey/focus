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

  # def column(name : String, type : T.class) : Focus::Column(T) forall T
  #   column?(name, type) || raise "Column '#{name}' not found in table '#{table_name}'"
  # end

  # def column?(name : String, type : T.class) : Focus::Column(T)? forall T
  #   columns.select(Focus::Column(T)).find { |col| col.name == name }
  # end

  def insert(*columns : Focus::Column) : Focus::InsertStatement
    Focus.insert(self, *columns)
  end

  # def update : Focus::UpdateStatement
  #   Focus.update(self)
  # end

  # def delete : Focus::DeleteStatement
  #   Focus.delete(self)
  # end

  def select(*fields : Focus::Column | Focus::ProjectionExpression) : Focus::SelectStatement
    projections = fields.map { |field| (field.is_a?(Focus::Column) ? Focus::ProjectionExpression.new(field) : field).as(Focus::ProjectionExpression) }
    Focus.select(*projections).from(self)
  end

  def select : Focus::SelectStatement
    Focus.select.from(self)
  end

  def as_table_source : Focus::TableSource
    Focus::TableReferenceExpression.new(table_name)
  end
end

# class Focus::SubselectTable < Focus::Table
#   getter subquery : Focus::SelectExpression

#   def initialize(@subquery : Focus::SelectExpression)
#   end

#   def table_name : String
#     subquery.table_alias.not_nil!("Subselect table must have an alias")
#   end

#   def column?(name : String, type : T.class) : Focus::Column(T)? forall T
#     columns = subquery.columns
#     return nil if columns.nil?

#     col_expression = columns.select(Focus::ColumnDeclaringExpression(T)).find { |col| col.declared_name == name }
#     return nil if col_expression.nil?

#     name = col_expression.declared_name.not_nil!("Column must have a name")
#     Focus::Column(T).new(name: name, table_name: subquery.table_alias)
#   end
# end

# class Focus::JoinTable < Focus::Table
#   getter table : Focus::Table
#   getter joins : Array(Focus::JoinExpression) = [] of Focus::JoinExpression

#   def initialize(@table : Focus::Table)
#   end

#   def table_name : String
#     table.table_name
#   end

#   def column(name : String, type : T.class) : Focus::Column(T) forall T
#     table.column?(name, type) || begin
#       joins.each do |join|
#         col = join.join_table.column?(name, type)
#         return col if col
#       end
#     end || raise "Column '#{name}' not found"
#   end

#   def add_join(join : Focus::JoinExpression) : Focus::JoinTable
#     joins << join
#     self
#   end

#   def as_expression : Focus::TableExpression
#     Focus::TableExpression.new(name: table.table_name, table_alias: table.label, joins: joins)
#   end
# end
