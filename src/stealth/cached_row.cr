class Stealth::CachedRow
  def self.build(result_set : DB::ResultSet) : Stealth::CachedRow
    columns = [] of Stealth::BaseCachedColumn
    result_set.column_count.times do
      index = result_set.next_column_index
      name = result_set.column_name(index)
      columns << Stealth::CachedColumn.new(value: result_set.read, name: name)
    end
    new(columns)
  end

  getter columns : Array(Stealth::BaseCachedColumn)

  def initialize(@columns)
  end

  def get(column : Column(C)) : C? forall C
    index = -1
    col = columns.find do |col|
      index += 1
      col.name == column.name
    end
    return nil if col.nil?

    get(index, type: C)
  end

  def get(column : ColumnDeclaringExpression(C)) : C? forall C
    declared_name = column.declared_name
    if declared_name.nil? || declared_name.blank?
      raise "TODO: Label of the specified column cannot be null or blank."
    end

    columns.each_with_index do |column, idx|
      return get(idx, type: C) if column.name == declared_name
    end
  end

  def get(column_index : Int32, type : Int32.class) : Int32?
    get_int32(column_index)
  end

  def get(column_index : Int32, type : String.class) : String?
    get_str(column_index)
  end

  def get(column_index : Int32, type : Float64.class) : Float64?
    get_float64(column_index)
  end

  def get_int32(column_index : Int32) : Int32?
    val = columns[column_index].value
    case val
    when Int32, Int64, Float32, Float64
      val.to_i
    when Bool
      val ? 1 : 0
    else
      val.try(&.to_s.to_i)
    end
  end

  def get_str(column_index : Int32) : String?
    val = columns[column_index].value
    case val
    when String
      val
    else
      val.try(&.to_s)
    end
  end

  def get_float64(column_index : Int32) : Float64?
    val = columns[column_index].value
    case val
    when Int32, Int64, Float32, Float64
      val.to_f
    when Bool
      val ? 1.0 : 0.0
    else
      val.try(&.to_s.to_f)
    end
  end
end
