class Stealth::SelectExpression
  include Stealth::QueryExpression

  getter columns : Array(Stealth::BaseColumnDeclaringExpression)
  getter from : Stealth::QuerySourceExpression
  getter where : Stealth::ScalarExpression(Bool)?

  def initialize(@from, @columns = [] of Stealth::BaseColumnDeclaringExpression, @where = nil)
  end
end
