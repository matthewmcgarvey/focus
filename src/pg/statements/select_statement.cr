class Focus::PG::SelectStatement < Focus::PG::Statement
  getter select_clause : Focus::SelectClause
  property from_clause : Focus::FromClause?
  property where_clause : Focus::WhereClause?
  property group_by_clause : Focus::GroupByClause?
  property having_clause : Focus::HavingClause?
  property order_by_clauses : Focus::OrderByListClause?
  property limit_clause : Focus::LimitClause?
  property offset_clause : Focus::OffsetClause?

  def initialize(@select_clause : Focus::SelectClause)
  end

  def distinct : self
    select_clause.distinct = true
    self
  end

  def from(table : Focus::ReadableTable) : self
    @from_clause = Focus::FromClause.new(table)
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

  def order_by(*clauses : Focus::OrderByClause) : self
    self.order_by_clauses ||= Focus::OrderByListClause.new
    if list = self.order_by_clauses
      clauses.each do |clause|
        list.order_bys << clause
      end
    end
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

  def aliased(label : String) : Focus::SelectTable
    Focus::SelectTable.new(self, label)
  end

  def as_cte(label : String) : Focus::CommonTableExpression
    Focus::CommonTableExpression.new(self, label)
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::SELECT_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    [
      select_clause,
      from_clause,
      where_clause,
      group_by_clause,
      having_clause,
      order_by_clauses,
      limit_clause,
      offset_clause,
    ].compact
  end
end
