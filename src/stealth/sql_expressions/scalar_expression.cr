module Stealth::ScalarExpression(T)
  include Stealth::BaseScalarExpression

  getter sql_type : T.class
end
