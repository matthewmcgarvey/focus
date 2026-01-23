class Focus::OnConflictClause < Focus::Clause
  getter columns : Array(Focus::ColumnToken)
  getter! action : String

  def initialize(@columns : Array(Focus::ColumnToken))
  end

  def do_update : Nil
    @action = "DO UPDATE"
  end

  def do_nothing : Nil
    @action = "DO NOTHING"
  end
end
