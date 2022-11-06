class Stealth::CachedRow
  def self.build(result_set : DB::ResultSet, row_metadata : Stealth::RowMetadata) : Stealth::CachedRow
    columns = [] of Stealth::CachedColumn
    result_set.column_count.times do
      columns << Stealth::CachedColumn.new(value: result_set.read)
    end
    new(columns, row_metadata)
  end

  private getter columns : Array(Stealth::CachedColumn)
  private getter row_metadata : Stealth::RowMetadata

  def initialize(@columns, @row_metadata)
  end

  def get(column : Column(C)) : C? forall C
    index = -1
    field = row_metadata.fields.find do |f|
      index += 1
      f.name == column.name
    end
    return nil if field.nil?

    get(index, type: C)
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
