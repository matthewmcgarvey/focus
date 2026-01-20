class Focus::SQLite::SetStatement < Focus::SetStatement
  include Focus::SQLite::Statement
  include Focus::SQLite::Statements::Dsl::SetOperators
end
