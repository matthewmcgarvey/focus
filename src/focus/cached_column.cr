module Focus::BaseCachedColumn
  abstract def value
  abstract def name : String
end

class Focus::CachedColumn(T)
  include Focus::BaseCachedColumn
  getter value : T
  getter name : String

  def initialize(@value, @name)
  end
end
