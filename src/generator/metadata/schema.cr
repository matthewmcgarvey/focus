class Focus::Metadata::Schema
  getter tables_metadata : Array(Table)
  getter views_metadata : Array(Table)

  def initialize(@tables_metadata : Array(Table), @views_metadata : Array(Table))
  end

  def empty? : Bool
    tables_metadata.empty? && views_metadata.empty?
  end
end
