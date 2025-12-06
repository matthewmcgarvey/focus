# helpers for generating methods across column classes
module Focus::ColumnMacros
  macro scalar_wrappers(scalar_type, expr_type, *ops)
    {% for op in ops %}
      def {{op.id}}(value : {{scalar_type.id}}) : Focus::BoolExpression
        {{op.id}}({{expr_type.id}}.new(value))
      end
    {% end %}
  end
end
