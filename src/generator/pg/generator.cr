class Focus::PG::Generator
  def self.from_url(url : String, dest_dir : String, template : Focus::Template, schema : String) : self
    uri = URI.parse(url)
    db_name = uri.path.split('/').last

    new(DB.open(url), File.join(dest_dir, db_name), db_name, template, schema)
  end

  private getter db : Focus::DBConn
  private getter dest_dir : String
  private getter db_name : String
  private getter template : Focus::Template
  private getter schema : String

  def initialize(@db : Focus::DBConn, @dest_dir : String, @db_name : String, @template : Focus::Template, @schema : String)
  end

  def generate
    query_set = Focus::PG::QuerySet.new(db)
    schema_metadata = query_set.get_schema(schema)
    template.process_schema(dest_dir, db_name, schema_metadata)
  end
end
