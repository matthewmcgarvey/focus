module Stealth::Dsl::Aggregation
  def min(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::MIN, column.as_expression, is_distinct: false, sql_type: column.sql_type)
  end

  def min_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::MIN, column.as_expression, is_distinct: true, sql_type: column.sql_type)
  end

  def max(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::MAX, column.as_expression, is_distinct: false, sql_type: column.sql_type)
  end

  def max_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::MAX, column.as_expression, is_distinct: true, sql_type: column.sql_type)
  end

  def avg(column : ColumnDeclaring(Comparable)) : AggregateExpression(Float32)
    AggregateExpression.new(AggregateType::AVG, column.as_expression, is_distinct: false, sql_type: Float32)
  end

  def avg_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Float32)
    AggregateExpression.new(AggregateType::AVG, column.as_expression, is_distinct: true, sql_type: Float32)
  end

  def sum(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::SUM, column.as_expression, is_distinct: false, sql_type: column.sql_type)
  end

  def sum_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression
    AggregateExpression.new(AggregateType::SUM, column.as_expression, is_distinct: true, sql_type: column.sql_type)
  end

  def count(column : ColumnDeclaring(Comparable)? = nil) : AggregateExpression(Int32)
    AggregateExpression.new(AggregateType::COUNT, column.try(&.as_expression), is_distinct: false, sql_type: Int32)
  end

  def count_distinct(column : ColumnDeclaring(Comparable)) : AggregateExpression(Int32)
    AggregateExpression.new(AggregateType::COUNT, column.as_expression, is_distinct: true, sql_type: Int32)
  end
end
