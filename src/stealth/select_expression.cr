class Stealth::SelectExpression
  include Stealth::SqlExpression

  getter columns : Array(Stealth::BaseColumnDeclaringExpression)
  getter from : Stealth::TableExpression
  getter where : Stealth::ScalarExpression(Bool)?

  def initialize(@columns, @from, @where = nil)
  end
end
