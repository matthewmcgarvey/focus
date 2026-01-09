class Focus::PGTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::PGDialect.new
end
