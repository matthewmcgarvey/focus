module Focus::PG::Dsl::Columns
  def bool_array_column(name : String) : Focus::ArrayColumn(Bool)
    Focus::ArrayColumn(Bool).new(name)
  end
end
