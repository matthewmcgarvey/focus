class Focus::SQLite::QuerySet < Focus::QuerySet
  getter db : Focus::DBConn

  def initialize(@db)
  end

  # table_type can be "table" or "view"
  def get_tables_metadata(schema_name : String, table_type : TableType) : Array(Metadata::Table)
    query = <<-SQL
      SELECT name
      FROM sqlite_master
      WHERE type=? AND name != 'sqlite_sequence'
      ORDER BY name;
    SQL

    table_type_str = case table_type
                     when .base_table?
                       "table"
                     when .view_table?
                       "view"
                     end

    table_names = db.query_all(query, args: [table_type_str], as: String)
    tables = table_names.map { |table_name| Metadata::Table.new(table_name) }

    tables.each do |table|
      table.columns = get_table_columns_metadata(db, table.name)
    end

    tables
  end

  def get_table_columns_metadata(db : Focus::DBConn, table_name : String) : Array(Metadata::Column)
    query = "SELECT * FROM pragma_table_xinfo(?);"
    result_type = {cid: Int32, name: String, type: String, not_null: Int32, dflt_value: String?, pk: Int32}
    results = db.query_all(query, args: [table_name], as: result_type)

    results.map do |result|
      column_type = result[:type].split("(").first.strip
      is_generated = false
      has_default = !result[:dflt_value].nil?

      data_type = Metadata::Column::DataType.new(
        name: column_type,
        kind: "base",
        is_unsigned: false
      )

      Metadata::Column.new(
        name: result[:name],
        is_primary_key: result[:pk] != 0,
        is_nullable: result[:not_null] != 1,
        is_generated: is_generated,
        has_default: has_default,
        data_type: data_type
      )
    end
  end
end
