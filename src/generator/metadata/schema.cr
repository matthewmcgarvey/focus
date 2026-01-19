class Focus::Metadata::Schema
  getter tables_metadata : Array(Table)
  getter views_metadata : Array(Table)
  getter enums_metadata : Array(Enum)

  def initialize(@tables_metadata : Array(Table), @views_metadata : Array(Table), @enums_metadata : Array(Enum))
  end

  def empty? : Bool
    tables_metadata.empty? && views_metadata.empty? && enums_metadata.empty?
  end
end
