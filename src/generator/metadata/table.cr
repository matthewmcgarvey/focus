class Focus::Metadata::Table
  getter name : String
  property comment : String?
  property columns : Array(Column)?

  def initialize(@name : String)
  end
end
