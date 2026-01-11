class Focus::SelectClause < Focus::Clause
  getter projections : Array(Focus::Expression)
  property? distinct : Bool = false

  def initialize(@projections : Array(Focus::Expression))
  end
end
