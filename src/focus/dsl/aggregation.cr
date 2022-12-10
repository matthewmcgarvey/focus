module Focus::Dsl::Aggregation
  def min(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::MIN, column.as_expression, is_distinct: false)
  end

  def min_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::MIN, column.as_expression, is_distinct: true)
  end

  def max(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::MAX, column.as_expression, is_distinct: false)
  end

  def max_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::MAX, column.as_expression, is_distinct: true)
  end

  def avg(column : ColumnDeclaring(Comparable)) : AggregateExpression(Float32)
    AggregateExpression(Float32).new(AggregateType::AVG, column.as_expression, is_distinct: false)
  end

  def avg_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Float32)
    AggregateExpression(Float32).new(AggregateType::AVG, column.as_expression, is_distinct: true)
  end

  def sum(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::SUM, column.as_expression, is_distinct: false)
  end

  def sum_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Comparable)
    AggregateExpression(Comparable).new(AggregateType::SUM, column.as_expression, is_distinct: true)
  end

  def count(column : ColumnDeclaring(Comparable)? = nil) : AggregateExpression(Int32)
    AggregateExpression(Int32).new(AggregateType::COUNT, column.try(&.as_expression), is_distinct: false)
  end

  def count_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Int32)
    AggregateExpression(Int32).new(AggregateType::COUNT, column.as_expression, is_distinct: true)
  end
end
