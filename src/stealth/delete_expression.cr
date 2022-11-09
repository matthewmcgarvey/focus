class Stealth::DeleteExpression
  include Stealth::SqlExpression
  getter table : TableExpression
  getter where : ScalarExpression(Bool)?

  def initialize(@table, @where)
  end
end
