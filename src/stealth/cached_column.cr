class Stealth::CachedColumn
  getter value : DB::Any
  getter name : String

  def initialize(@value, @name)
  end
end
