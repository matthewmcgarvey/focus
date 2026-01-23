class Focus::SetClause < Focus::Clause
  getter set_columns : Array(Column) = [] of Column

  def add_column(column : Focus::ColumnToken, value : Focus::Expression | Focus::SelectStatement)
    set_columns << Column.new(column, value)
  end

  class Column < Focus::Clause
    getter column : Focus::ColumnToken
    getter value : Focus::Expression | Focus::SelectStatement

    def initialize(@column : Focus::ColumnToken, @value : Focus::Expression | Focus::SelectStatement)
    end
  end
end
