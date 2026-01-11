class Focus::OrderByListClause < Focus::Clause
  getter order_bys : Array(Focus::OrderByClause) = [] of Focus::OrderByClause
end
