class Focus::Int64Expression < Focus::Expression
  include Focus::Parameter

  getter value : Int64

  def initialize(@value : Int64)
  end
end
