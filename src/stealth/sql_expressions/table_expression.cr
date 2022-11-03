struct Stealth::TableExpression < Stealth::QuerySourceExpression
  getter name : String

  def initialize(@name : String)
  end
end
