abstract class Focus::Dialect
  getter name : String
  getter package_name : String

  def initialize(@name : String, @package_name : String)
  end

  def formatter : Focus::SqlVisitor
    old_formatter
  end

  def old_formatter : Focus::SqlFormatter
    Focus::SqlFormatter.new
  end

  def token_formatter : Focus::TokenFormatter
    Focus::TokenFormatter.new
  end
end
