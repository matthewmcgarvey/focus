class Focus::MySqlTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::MySqlDialect.new
end
