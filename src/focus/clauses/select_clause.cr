class Focus::SelectClause < Focus::Clause
  getter projections : Array(Focus::Expression)
  property? distinct : Bool = false
  property distinct_on_columns : Array(Focus::Column)?

  def initialize(@projections : Array(Focus::Expression))
  end
end
