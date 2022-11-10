module Stealth::BaseCachedColumn
  abstract def value
  abstract def name : String
end

class Stealth::CachedColumn(T)
  include Stealth::BaseCachedColumn
  getter value : T
  getter name : String

  def initialize(@value, @name)
  end
end
