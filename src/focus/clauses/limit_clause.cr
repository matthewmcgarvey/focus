class Focus::LimitClause < Focus::Clause
  getter limit : Int32

  def initialize(@limit : Int32)
  end
end
