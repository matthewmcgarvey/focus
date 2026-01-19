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

  abstract def get_tables_metadata(schema_name : String, table_type : TableType) : Array(Metadata::Table)
  abstract def get_enums_metadata(schema_name : String) : Array(Metadata::Enum)

  def get_schema(schema : String) : Metadata::Schema
    tables_metadata = get_tables_metadata(schema, TableType::BaseTable)
    views_metadata = get_tables_metadata(schema, TableType::ViewTable)
    enums_metadata = get_enums_metadata(schema)
    Metadata::Schema.new(tables_metadata, views_metadata, enums_metadata)
  end
end
