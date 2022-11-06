module Stealth::BaseField
  getter name : String

  abstract def type
end

class Stealth::Field(T)
  include Stealth::BaseField

  getter type : T.class

  def initialize(@name, @type)
  end
end
