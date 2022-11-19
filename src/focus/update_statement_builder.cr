class Focus::UpdateStatementBuilder < Focus::AssignmentsBuilder
  getter where : Focus::ColumnDeclaring(Bool)?

  def where(@where)
  end
end
