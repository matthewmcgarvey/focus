class Stealth::InsertExpression
  include Stealth::SqlExpression

  getter table : Stealth::TableExpression
  getter assignments : Array(BaseColumnAssignmentExpression)

  def initialize(@table, @assignments)
  end
end
