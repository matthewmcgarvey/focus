abstract class Focus::Dialect
  getter name : String
  getter package_name : String

  def initialize(@name : String, @package_name : String)
  end
end
