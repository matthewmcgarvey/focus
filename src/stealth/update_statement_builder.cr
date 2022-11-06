class Stealth::UpdateStatementBuilder < Stealth::AssignmentsBuilder
  getter where : Stealth::ColumnDeclaring(Bool)?

  def where(@where)
  end
end
