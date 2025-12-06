module Focus::UpdateableTable
  def insert(*columns : Focus::Column) : Focus::InsertStatement
    Focus.insert(self, *columns)
  end

  def update : Focus::UpdateStatement
    Focus.update(self)
  end

  def delete : Focus::DeleteStatement
    Focus.delete(self)
  end
end
