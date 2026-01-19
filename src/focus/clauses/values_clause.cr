class Focus::ValuesClause < Focus::Clause
  getter rows : Array(Row) = [] of Row

  def add_row(values : Array(Focus::Expression)) : Nil
    self.rows << Row.new(values)
  end

  class Row < Focus::Clause
    getter values : Array(Focus::Expression)

    def initialize(@values : Array(Focus::Expression))
    end
  end
end
