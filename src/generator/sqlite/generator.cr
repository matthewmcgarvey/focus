class Focus::SQLiteGenerator
  private getter db : Focus::DBConn
  private getter dest_dir : String
  private getter template : Focus::Template

  def initialize(@db : Focus::DBConn, @dest_dir : String, @template : Focus::Template)
  end

  def generate
    query_set = Focus::SQLiteQuerySet.new(db)
    metadata = query_set.get_tables_metadata("table")
    pp metadata
  end
end
