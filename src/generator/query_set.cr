abstract class Focus::QuerySet
  abstract def get_tables_metadata(schema_name : String, table_type : String) : Array(Metadata::Table)

  def get_schema(schema : String) : Metadata::Schema
    tables_metadata = get_tables_metadata(schema, "table")
    Metadata::Schema.new(tables_metadata)
  end
end
