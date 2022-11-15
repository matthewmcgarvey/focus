module Stealth::Entity
  abstract def initialize(row : Stealth::CachedRow)

  macro included
    extend ClassMethods
  end

  module ClassMethods
    abstract def setup(query_source : Stealth::QuerySource) : Stealth::Query
    abstract def table : Stealth::Table
  end
end
