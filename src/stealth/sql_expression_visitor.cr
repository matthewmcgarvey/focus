class Stealth::SqlExpressionVisitor
  private getter sql_string_builder = String::Builder.new

  def visit(expression : Stealth::SelectExpression)
    sql_string_builder << "SELECT"
    expression.columns.each_with_index do |column, idx|
      if idx > 0
        sql_string_builder << ","
      end
      visit(column)
    end
    visit(expression.from)
  end

  def visit(expression : Stealth::ColumnExpression)
    sql_string_builder << " #{expression.name}"
  end

  def visit(expression : Stealth::TableExpression)
    sql_string_builder << " FROM #{expression.name}"
  end

  def to_sql : String
    sql_string_builder.to_s
  end
end
