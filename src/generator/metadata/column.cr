class Focus::Metadata::Column
  class DataType
    getter name : String
    getter kind : String
    getter is_unsigned : Bool
    getter dimensions : Int32?

    def initialize(@name, @kind, @is_unsigned, @dimensions = nil)
    end
  end

  getter name : String
  getter is_primary_key : Bool
  getter is_nullable : Bool
  getter is_generated : Bool
  getter has_default : Bool
  getter data_type : DataType
  getter comment : String?

  def initialize(@name, @is_primary_key, @is_nullable, @is_generated, @has_default, @data_type, @comment = nil)
  end
end
