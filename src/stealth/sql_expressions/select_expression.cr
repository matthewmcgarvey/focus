class Stealth::SelectExpression < Stealth::QueryExpression
  getter columns : Array(Stealth::BaseColumnExpression)
  getter from : Stealth::QuerySourceExpression

  def initialize(@columns : Array(Stealth::BaseColumnExpression), @from : Stealth::QuerySourceExpression)
  end
end
