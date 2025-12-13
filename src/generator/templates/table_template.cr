class Focus::Templates::TableTemplate
  getter table_name : String
  getter title_name : String
  getter columns : Array(ColumnTemplate)

  def initialize(table : Metadata::Table)
    @table_name = table.name
    @title_name = table.name.camelcase
    @columns = table.columns.try(&.map { |column| ColumnTemplate.new(column) }) || [] of ColumnTemplate
  end

  class ColumnTemplate
    getter name : String
    getter column_type : String

    def initialize(column : Metadata::Column)
      @name = column.name
      @column_type = to_column_type(column.data_type)
    end

    private def to_column_type(data_type : Metadata::Column::DataType) : String
      case data_type.name.upcase
      when "BOOLEAN", "BOOL"
        "Bool"
      when "INTEGER"
        "Int32"
      when "TEXT"
        "String"
      else
        "String"
      end
    end
  end

  ECR.def_to_s "#{__DIR__}/table_template.ecr"
end
