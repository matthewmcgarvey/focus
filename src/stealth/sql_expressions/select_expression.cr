class Stealth::SelectExpression < Stealth::QueryExpression
  getter columns : Array(Stealth::ColumnExpression)
  getter from : Stealth::QuerySourceExpression

  def initialize(@columns : Array(Stealth::ColumnExpression), @from : Stealth::QuerySourceExpression)
  end
end
