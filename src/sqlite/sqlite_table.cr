class Focus::SQLiteTable < Focus::Table
  getter dialect : Focus::Dialect = Focus::SQLiteDialect.new
end
