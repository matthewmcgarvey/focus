abstract class Focus::Dialect
  getter name : String
  getter package_name : String

  def initialize(@name : String, @package_name : String)
  end

  def formatter : Focus::SqlFormatter
    Focus::SqlFormatter.new
  end
end
