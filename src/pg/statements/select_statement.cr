class Focus::PG::SelectStatement < Focus::PG::Statement
  getter select_clause : Focus::SelectClause
  property from_clause : Focus::FromClause?
  property where_clause : Focus::WhereClause?
  property group_by_clause : Focus::GroupByClause?
  property having_clause : Focus::HavingClause?
  property order_by_clause : Focus::OrderByClause?
  property limit_clause : Focus::LimitClause?
  property offset_clause : Focus::OffsetClause?

  def initialize(@select_clause : Focus::SelectClause)
  end

  def distinct : self
    select_clause.distinct = true
    self
  end

  def from(table : Focus::Table) : self
    from(Focus::TableReferenceExpression.new(table.table_name, table_alias: table.table_alias))
  end

  def from(table_source : Focus::TableSource) : self
    @from_clause = Focus::FromClause.new(table_source)
    self
  end

  def where(expression : Focus::BoolExpression) : self
    @where_clause = Focus::WhereClause.new(expression)
    self
  end

  def group_by(*columns : Focus::Column) : self
    @group_by_clause = Focus::GroupByClause.new(columns.select(Focus::Expression))
    self
  end

  def having(expression : Focus::BoolExpression) : self
    @having_clause = Focus::HavingClause.new(expression)
    self
  end

  def order_by(*expressions : Focus::OrderByExpression) : self
    clause = Focus::OrderByClause.new
    expressions.each { |expr| clause.order_bys << expr }
    @order_by_clause = clause
    self
  end

  def limit(limit : Int32) : self
    @limit_clause = Focus::LimitClause.new(limit)
    self
  end

  def offset(offset : Int32) : self
    @offset_clause = Focus::OffsetClause.new(offset)
    self
  end

  def aliased(label : String) : Focus::SubqueryExpression
    Focus::SubqueryExpression.new(self, label)
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      select_clause,
      from_clause,
      where_clause,
      group_by_clause,
      having_clause,
      order_by_clause,
      limit_clause,
      offset_clause,
    ].compact
  end
end
