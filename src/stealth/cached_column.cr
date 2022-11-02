class Stealth::CachedColumn
  getter value : DB::Any

  def initialize(@value : DB::Any)
  end
end
