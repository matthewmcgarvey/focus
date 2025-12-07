abstract class Focus::QuerySet
  abstract def get_tables_metadata(table_type : String) : Array(Metadata::Table)
end
