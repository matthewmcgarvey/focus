class Focus::Metadata::Schema
  getter name : String?
  getter tables_metadata : Array(Table)
  getter views_metadata : Array(Table)
  getter enums_metadata : Array(Enum)

  def initialize(@name : String?, @tables_metadata : Array(Table), @views_metadata : Array(Table), @enums_metadata : Array(Enum))
  end

  def empty? : Bool
    tables_metadata.empty? && views_metadata.empty? && enums_metadata.empty?
  end
end
