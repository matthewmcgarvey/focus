module Focus::Dsl::Columns
  def int32_column(name : String) : Focus::IntColumn(Int32)
    Focus::IntColumn(Int32).new(name)
  end

  def int64_column(name : String) : Focus::IntColumn(Int64)
    Focus::IntColumn(Int64).new(name)
  end

  def float32_column(name : String) : Focus::FloatColumn(Float32)
    Focus::FloatColumn(Float32).new(name)
  end

  def float64_column(name : String) : Focus::FloatColumn(Float64)
    Focus::FloatColumn(Float64).new(name)
  end

  def bool_column(name : String) : Focus::BoolColumn
    Focus::BoolColumn.new(name)
  end

  def string_column(name : String) : Focus::StringColumn
    Focus::StringColumn.new(name)
  end

  def time_column(name : String) : Focus::TimeColumn
    Focus::TimeColumn.new(name)
  end
end
