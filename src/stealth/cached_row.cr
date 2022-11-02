class Stealth::CachedRow
  def self.from_result_set(result_set : DB::ResultSet) : Stealth::CachedRow
    columns = [] of Stealth::CachedColumn
    result_set.column_count.times do
      columns << Stealth::CachedColumn.new(value: result_set.read)
    end
    new(columns)
  end

  private getter columns : Array(Stealth::CachedColumn)

  def initialize(@columns : Array(Stealth::CachedColumn))
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
    val = columns[column_index]
    case val
    when String
      val
    else
      val.try(&.to_s)
    end
  end
end
