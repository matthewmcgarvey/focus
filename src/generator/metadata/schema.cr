class Focus::Metadata::Schema
  getter tables_metadata : Array(Table)

  def initialize(@tables_metadata : Array(Table))
  end

  def empty? : Bool
    tables_metadata.empty?
  end
end
