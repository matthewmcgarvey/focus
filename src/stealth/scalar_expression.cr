require "./column_declaring"

module Stealth::BaseScalarExpression
  include Stealth::SqlExpression
end

module Stealth::ScalarExpression(T)
  include Stealth::BaseScalarExpression
  include Stealth::ColumnDeclaring(T)

  def as_expression : Stealth::ScalarExpression(T)
    self
  end

  def wrap_argument(argument : T) : Stealth::ArgumentExpression(T)
    ArgumentExpression.new(argument, sql_type)
  end

  def aliased(label : String? = nil) : Stealth::ColumnDeclaringExpression(T)
    Stealth::ColumnDeclaringExpression.new(self, label)
  end

  def as_declaring_expression : Stealth::ColumnDeclaringExpression(T)
    aliased(nil)
  end
end
