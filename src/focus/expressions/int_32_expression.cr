class Focus::Int32Expression < Focus::Expression
  include Focus::Parameter

  getter value : Int32

  def initialize(@value : Int32)
  end
end
