abstract class Focus::QuerySet
  enum TableType
    BaseTable
    ViewTable

    def to_sql : String
      case self
      when .base_table?
        "BASE TABLE"
      when .view_table?
        "VIEW"
      else
        raise "unreachable"
      end
    end
  end
end
