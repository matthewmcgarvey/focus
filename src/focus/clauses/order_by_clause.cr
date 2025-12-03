class Focus::OrderByClause < Focus::Clause
  getter order_bys : Array(Focus::OrderByExpression) = [] of Focus::OrderByExpression
end
