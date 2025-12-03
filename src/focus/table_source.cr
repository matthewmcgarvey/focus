module Focus::TableSource
  include Focus::Joinable

  def as_table_source : TableSource
    self
  end
end
