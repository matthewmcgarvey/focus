require "./sql_visitor"

class Stealth::RowMetadataVisitor < Stealth::SqlVisitor
  private getter fields = [] of Stealth::BaseField

  def build_metadata : Stealth::RowMetadata
    Stealth::RowMetadata.new(fields: fields)
  end

  def visit(expression : Stealth::SelectExpression)
    visit_list(expression.columns)
  end

  def visit(expression : Stealth::ColumnDeclaringExpression(T)) forall T
    expression.expression.accept(self)
  end

  def visit(expression : Stealth::ColumnExpression(T)) forall T
    fields << Stealth::Field.new(expression.name, expression.sql_type)
  end

  protected def visit_list(expressions : Array(Stealth::SqlExpression))
    expressions.each do |expression|
      expression.accept(self)
    end
  end
end
