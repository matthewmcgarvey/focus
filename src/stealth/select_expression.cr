class Stealth::SelectExpression
  include Stealth::QueryExpression

  getter columns : Array(Stealth::BaseColumnDeclaringExpression)
  getter from : Stealth::QuerySourceExpression
  getter where : Stealth::ScalarExpression(Bool)?

  def initialize(@columns, @from, @where = nil)
  end
end
