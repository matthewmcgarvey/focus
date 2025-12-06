module Focus::ReadableTable
  include Focus::Joinable

  def select(*fields : Focus::Column | Focus::ProjectionExpression | Focus::AggregateExpression) : Focus::SelectStatement
    projections = fields.map { |field| (field.is_a?(Focus::ProjectionExpression) ? field : Focus::ProjectionExpression.new(field)).as(Focus::ProjectionExpression) }
    Focus.select(*projections).from(self)
  end

  def select : Focus::SelectStatement
    Focus.select.from(self)
  end

  def aliased(table_alias : String? = nil) : Focus::Table
    self.class.new(table_name, table_alias)
  end
end
