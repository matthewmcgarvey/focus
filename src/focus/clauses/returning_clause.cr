class Focus::ReturningClause < Focus::Clause
  getter columns : Array(Focus::Column)

  def initialize(@columns : Array(Focus::Column))
  end
end
