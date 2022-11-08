class Stealth::TableExpression
  include Stealth::QuerySourceExpression

  getter name : String
  getter table_alias : String?
  getter catalog : String?
  getter schema : String?

  def initialize(@name, @table_alias = nil, @catalog = nil, @schema = nil)
  end

  def wrap_in_parens? : Bool
    false
  end
end
