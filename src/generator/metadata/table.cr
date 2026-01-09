class Focus::Metadata::Table
  getter name : String
  property comment : String?
  property columns : Array(Column)?

  def initialize(@name : String, @comment : String? = nil)
  end
end
