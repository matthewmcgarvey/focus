class Focus::PG::SetStatement < Focus::SetStatement
  include Focus::PG::Statement
  include Focus::PG::Statements::Dsl::SetOperators
end
