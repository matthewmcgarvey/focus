abstract class Focus::SqlVisitor
  abstract def visit_statement(statement : Focus::Statement) : Nil
  abstract def visit_clause(clause : Focus::Clause) : Nil
  abstract def visit_expression(expression : Focus::Expression) : Nil
  abstract def visit_token(token : Focus::Token) : Nil
  abstract def to_sql : String
  abstract def parameters : Array(DB::Any)
end
