class Focus::Metadata::Enum
  getter name : String
  getter values : Array(String)
  property comment : String?

  def initialize(@name : String, @values : Array(String), @comment : String? = nil)
  end
end
