abstract class Focus::QuerySet
  abstract def get_tables_metadata(table_type : String) : Array(Metadata::Table)

  def get_schema : Metadata::Schema
    tables_metadata = get_tables_metadata("table")
    Metadata::Schema.new(tables_metadata)
  end
end
