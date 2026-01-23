abstract class Focus::Table
  include Focus::UpdateableTable
  include Focus::ReadableTable
  include Focus::SerializableTable

  getter schema_name : String?
  getter table_name : String
  getter table_alias : String?
  getter columns : Array(Focus::Expression)

  abstract def dialect : Focus::Dialect

  def initialize(@schema_name : String?, @table_name : String, @table_alias : String?, @columns : Array(Focus::Expression))
    @columns.each do |col|
      if col.is_a?(Focus::Column)
        col.table_name = @table_alias || @table_name
      end
    end
  end

  def aliased(table_alias : String? = nil) : self
    self.class.new(schema_name, table_name, table_alias)
  end

  def excluded : self
    self.class.new(nil, "excluded", nil)
  end
end
