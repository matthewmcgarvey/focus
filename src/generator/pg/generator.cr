class Focus::PG::Generator
  private getter db : Focus::DBConn
  private getter dest_dir : String
  private getter template : Focus::Template
  private getter schema : String

  def initialize(@db : Focus::DBConn, @dest_dir : String, @template : Focus::Template, @schema : String)
  end

  def generate
    query_set = Focus::PG::QuerySet.new(db)
    schema_metadata = query_set.get_schema(schema)
    template.process_schema(dest_dir, schema_metadata)
  end
end
