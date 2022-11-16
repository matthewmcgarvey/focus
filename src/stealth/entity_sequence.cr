class Stealth::EntitySequence(E)
  include Enumerable(E)

  getter query : Stealth::Query
  getter entity_class : E.class

  def initialize(@query, @entity_class : E.class)
  end

  def each(&block : E -> Nil)
    query.each do |row|
      yield entity_class.new(row)
    end
  end
end
