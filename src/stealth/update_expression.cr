class Stealth::UpdateExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter assignments : Array(Stealth::BaseColumnAssignmentExpression)
  getter where : Stealth::ScalarExpression(Bool)?

  def initialize(@table, @assignments, @where = nil)
  end
end
