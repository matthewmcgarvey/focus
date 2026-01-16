abstract class Focus::NumericExpression < Focus::Expression
  def pow(exponent : Focus::NumericExpression) : Focus::FloatExpression(Float64)
    expression = Focus::FunctionExpression.new("POW", [self, exponent])
    Focus::FloatExpression(Float64).new(expression)
  end

  private def _add(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "+")
  end

  private def _sub(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "-")
  end

  private def _mul(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "*")
  end

  private def _div(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "/")
  end

  private def _mod(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "%")
  end

  private def _mod(rhs : Focus::NumericExpression) : Focus::BinaryOperatorExpression
    Focus::BinaryOperatorExpression.new(self, rhs, "%")
  end
end
