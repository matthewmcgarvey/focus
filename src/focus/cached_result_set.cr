class Focus::CachedResultSet < DB::ResultSet
  private property current_row_count = -1
  private property current_column_count = -1
  private getter cached_rows
  private getter inner : DB::ResultSet

  def initialize(@cached_rows : Array(CachedRow), @inner)
    super(inner.statement)
  end

  def move_next : Bool
    if cached_rows.size == current_row_count + 1
      false
    else
      self.current_row_count += 1
      self.current_column_count = -1
      true
    end
  end

  def column_count : Int32
    inner.column_count
  end

  def column_name(index : Int32) : String
    inner.column_name(index)
  end

  def read
    self.current_column_count += 1
    value = current_row.columns[current_column_count].value
    value
  end

  def next_column_index : Int32
    current_column_count + 1
  end

  private def current_row : CachedRow
    cached_rows[current_row_count]
  end
end
