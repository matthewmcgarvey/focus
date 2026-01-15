class Focus::SQLiteFormatter < Focus::SqlFormatter
  def visit_statement(statement : Focus::SQLite::WithStatement) : Nil
    self.statement_type = statement.statement_type
    write "WITH "
    visit_list statement.ctes
    statement.primary_statement.try(&.accept(self))
  end
end
