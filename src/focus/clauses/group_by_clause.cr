class Focus::GroupByClause < Focus::Clause
  getter group_bys : Array(Focus::Expression)

  def initialize(@group_bys : Array(Focus::Expression))
  end
end
