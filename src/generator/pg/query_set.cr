class Focus::PGQuerySet < Focus::QuerySet
  getter db : Focus::DBConn

  def initialize(@db)
  end

  # table_type can be "table" or "view"
  def get_tables_metadata(schema_name : String, table_type : String) : Array(Metadata::Table)
    query = <<-SQL
      SELECT table_name, obj_description((quote_ident(table_schema)||'.'||quote_ident(table_name))::regclass) AS table_comment
      FROM information_schema.tables
      WHERE table_schema = $1 AND table_type = $2
      ORDER BY table_name;
    SQL
    table_type = "BASE TABLE" if table_type == "table"

    table_names_and_comments = db.query_all(query, args: [schema_name, table_type], as: {String, String?})
    tables = table_names_and_comments.map { |(table_name, comment)| Metadata::Table.new(table_name, comment).as(Metadata::Table) }
    tables.concat(get_materialized_views(schema_name))

    tables.each do |table|
      table.columns = get_table_columns_metadata(db, schema_name, table.name)
    end

    tables
  end

  def get_materialized_views(schema_name : String) : Array(Metadata::Table)
    query = <<-SQL
      SELECT matviewname AS "table.name"
      FROM pg_matviews
      WHERE schemaname = $1;
    SQL

    table_names = db.query_all(query, args: [schema_name], as: String)
    table_names.map { |table_name| Metadata::Table.new(table_name) }
  end

  def get_table_columns_metadata(db : Focus::DBConn, schema_name : String, table_name : String) : Array(Metadata::Column)
    query = <<-SQL
      select
          attr.attname as "column.Name",
          col_description(attr.attrelid, attr.attnum) as "column.Comment",
          exists(
              select 1
              from pg_catalog.pg_index indx
              where attr.attrelid = indx.indrelid and attr.attnum = any(indx.indkey) and indx.indisprimary
          ) as "column.IsPrimaryKey",
          not attr.attnotnull as "column.isNullable",
          attr.attgenerated = 's' as "column.isGenerated",
          attr.atthasdef as "column.hasDefault",
          (case when tp.typcategory = 'A' then greatest(1, attr.attndims) --cockroach num dims fix
                else 0
              end) as "dataType.dimensions",
          (case coalesce(elem.typtype, tp.typtype)
              when 'b' then 'base'
              when 'd' then 'base'
              when 'e' then 'enum'
              when 'r' then 'range'
              end) as "dataType.Kind",
          (case when tp.typtype = 'd' then (select pg_type.typname from pg_catalog.pg_type where pg_type.oid = tp.typbasetype)
                when tp.typcategory = 'A' then elem.typname
                else tp.typname
              end) as "dataType.Name",
          false as "dataType.isUnsigned"
      from pg_catalog.pg_attribute as attr
          join pg_catalog.pg_class as cls on cls.oid = attr.attrelid
          join pg_catalog.pg_namespace as ns on ns.oid = cls.relnamespace
          join pg_catalog.pg_type as tp on tp.oid = attr.atttypid
  	 left join pg_catalog.pg_type elem ON tp.typelem = elem.oid -- only for arrays
      where
          ns.nspname = $1 and
          cls.relname = $2 and
          not attr.attisdropped and
          attr.attnum > 0
      order by
          attr.attnum;
    SQL
    db.query_all(query, args: [schema_name, table_name]) do |rs|
      Metadata::Column.new(
        name: rs.read(String),
        comment: rs.read(String?),
        is_primary_key: rs.read(Bool),
        is_nullable: rs.read(Bool),
        is_generated: rs.read(Bool),
        has_default: rs.read(Bool),
        data_type: Metadata::Column::DataType.new(
          dimensions: rs.read(Int32?),
          kind: rs.read(String),
          name: rs.read(String),
          is_unsigned: rs.read(Bool)
        ),
      )
    end
  end
end
