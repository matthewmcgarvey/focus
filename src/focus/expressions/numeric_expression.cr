abstract class Focus::NumericExpression < Focus::Expression
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
