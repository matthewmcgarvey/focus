class Focus::ValuesClause < Focus::Clause
  getter rows : Array(Row) = [] of Row

  def add_row(values : Array(Focus::ValueExpression)) : Nil
    self.rows << Row.new(values)
  end

  class Row < Focus::Clause
    getter values : Array(Focus::ValueExpression)

    def initialize(@values : Array(Focus::ValueExpression))
    end
  end
end
