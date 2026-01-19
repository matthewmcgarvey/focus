class Focus::SQLite::Generator
  def self.from_url(url : String, dest_dir : String, template : Focus::Template) : self
    uri = URI.parse(url)
    db_name = uri.path.split('/').last.rstrip(".db")

    new(DB.open(url), File.join(dest_dir, db_name), db_name, template)
  end

  private getter db : Focus::DBConn
  private getter dest_dir : String
  private getter db_name : String
  private getter template : Focus::Template

  def initialize(@db : Focus::DBConn, @dest_dir : String, @db_name : String, @template : Focus::Template)
  end

  def generate
    query_set = Focus::SQLite::QuerySet.new(db)
    schema_metadata = query_set.get_schema
    template.process_schema(dest_dir, db_name, schema_metadata)
  end
end
