class Focus::ReturningClause < Focus::Clause
  getter columns : Array(Focus::Expression)

  def initialize(@columns : Array(Focus::Expression))
  end
end
