class Focus::ColumnToken < Focus::Token
  getter column : String

  def initialize(@column : String)
  end
end
