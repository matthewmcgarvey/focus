class Focus::OffsetClause < Focus::Clause
  getter offset : Int32

  def initialize(@offset : Int32)
  end
end
