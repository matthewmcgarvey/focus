class Stealth::EntitySequence(E)
  getter query : Stealth::Query
  getter entity_class : E.class

  def initialize(@query, @entity_class : E.class)
  end

  def results : Enumerable(E)
    query.map { |row| entity_class.new(row) }
  end
end
