class Focus::SelectClause < Focus::Clause
  getter projections : Array(Focus::ProjectionExpression)
  property? distinct : Bool = false

  def initialize(@projections : Array(Focus::ProjectionExpression))
  end
end
