class Focus::Templates::TableTemplate
  getter dialect : Focus::Dialect
  getter table_name : String
  getter title_name : String
  getter columns : Array(ColumnTemplate)

  def initialize(@dialect : Focus::Dialect, table : Metadata::Table)
    @table_name = table.name
    @title_name = table.name.camelcase
    @columns = table.columns.try(&.map { |column| ColumnTemplate.new(dialect, column) }) || [] of ColumnTemplate
  end

  class ColumnTemplate
    getter dialect : Focus::Dialect
    getter name : String
    getter column_type : String

    def initialize(@dialect : Focus::Dialect, column : Metadata::Column)
      @name = column.name
      @column_type = to_column_type(column.data_type)
    end

    private def to_column_type(data_type : Metadata::Column::DataType) : String
      case data_type.name.upcase
      when "BOOLEAN", "BOOL"
        "BoolColumn"
      when "INTEGER", "INT4"
        "IntColumn(Int32)"
      when "INT8"
        "IntColumn(Int64)"
      when "TEXT", "VARCHAR"
        "StringColumn"
      when "DATE"
        "TimeColumn"
      else
        puts "unhandled type #{data_type.name}. defaulting to string"
        "StringColumn"
      end
    end
  end

  ECR.def_to_s "#{__DIR__}/table_template.ecr"
end
