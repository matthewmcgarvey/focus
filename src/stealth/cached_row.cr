class Stealth::CachedRow
  # Taken from https://github.com/luckyframework/avram/blob/f0148f4274798124f5457c85fa35f7ba985636b6/src/avram/charms/time_extensions.cr#L10-L23
  TIME_FORMATS = [
    Time::Format::ISO_8601_DATE_TIME,
    Time::Format::RFC_2822,
    Time::Format::RFC_3339,
    # HTML datetime-local inputs are basically RFC 3339 without the timezone:
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/datetime-local
    Time::Format.new("%Y-%m-%dT%H:%M:%S", Time::Location::UTC),
    Time::Format.new("%Y-%m-%dT%H:%M", Time::Location::UTC),
    # Dates and times go last, otherwise it will parse strings with both
    # dates *and* times incorrectly.
    Time::Format::HTTP_DATE,
    Time::Format::ISO_8601_DATE,
    Time::Format::ISO_8601_TIME,
  ]

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

  def get?(column : Column(C)) : C? forall C
    index = -1
    col = columns.find do |c|
      index += 1
      c.name == column.name
    end
    return nil if col.nil?

    get?(index, type: C)
  end

  def get(column : Column(C)) : C forall C
    get?(column).not_nil!
  end

  def get?(column : ColumnDeclaringExpression(C)) : C? forall C
    declared_name = column.declared_name
    if declared_name.nil? || declared_name.blank?
      raise "TODO: Label of the specified column cannot be null or blank."
    end

    columns.each_with_index do |col, idx|
      return get?(idx, type: C) if col.name == declared_name
    end
  end

  def get(column : ColumnDeclaringExpression(C)) : C forall C
    get?(column).not_nil!
  end

  def get?(column_index : Int32, type : Int16.class) : Int16?
    val = columns[column_index].value
    case val
    when Int16, Int32, Int64, Float32, Float64
      val.to_i16
    when Bool
      val ? 1_i16 : 0_i16
    else
      val.try(&.to_s.to_i16)
    end
  end

  def get(column_index : Int32, type : Int16.class) : Int16
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Int32.class) : Int32?
    val = columns[column_index].value
    case val
    when Int16, Int32, Int64, Float32, Float64
      val.to_i
    when Bool
      val ? 1 : 0
    when Nil
      nil
    else
      val.to_s.to_i
    end
  end

  def get(column_index : Int32, type : Int32.class) : Int32
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Int64.class) : Int64?
    val = columns[column_index].value
    case val
    when Int16, Int32, Int64, Float32, Float64
      val.to_i64
    when Bool
      val ? 1_i64 : 0_i64
    when Nil
      nil
    else
      val.to_s.to_i64
    end
  end

  def get(column_index : Int32, type : Int64.class) : Int64
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Float32.class) : Float32?
    val = columns[column_index].value
    case val
    when Int32, Int64, Float32, Float64
      val.to_f32
    when Bool
      val ? 1.0_f32 : 0.0_f32
    when Nil
      nil
    else
      val.to_s.to_f32
    end
  end

  def get(column_index : Int32, type : Float32.class) : Float32
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Float64.class) : Float64?
    val = columns[column_index].value
    case val
    when Int32, Int64, Float32, Float64
      val.to_f
    when Bool
      val ? 1.0 : 0.0
    when Nil
      nil
    else
      val.to_s.to_f64
    end
  end

  def get(column_index : Int32, type : Float64.class) : Float64
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : String.class) : String?
    val = columns[column_index].value
    case val
    when String
      val
    else
      val.try(&.to_s)
    end
  end

  def get(column_index : Int32, type : String.class) : String
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Bool.class) : Bool?
    val = columns[column_index].value
    case val
    when Bool
      val
    when Int16, Int32, Int64, Float32, Float64
      !val.zero?
    else
      !!val
    end
  end

  def get(column_index : Int32, type : Bool.class) : Bool
    get?(column_index, type).not_nil!
  end

  def get?(column_index : Int32, type : Time.class) : Time?
    val = columns[column_index].value
    return val if val.is_a? Time
    return if val.nil?

    str = val.to_s
    TIME_FORMATS.each do |format|
      begin
        return format.parse(str)
      rescue e : Time::Format::Error
        # do nothing
      end
    end
  end

  def get(column_index : Int32, type : Time.class) : Time
    get?(column_index, type).not_nil!
  end
end
