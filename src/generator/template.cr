require "file_utils"
require "ecr"
require "./templates/*"

class Focus::Template
  def self.dialect(dialect : Focus::Dialect) : Template
    new(dialect)
  end

  getter dialect : Focus::Dialect

  def initialize(@dialect : Focus::Dialect)
  end

  def process_schema(dest_dir : String, schema : Metadata::Schema)
    if schema.empty?
      puts "Nothing found to generate. Exiting..."
      return
    end

    schema_path = dest_dir

    puts "Destination directory: #{schema_path}"
    puts "Cleaning up destination directory..."

    FileUtils.rm_rf(schema_path)

    generate_table_models("tables", schema_path, schema.tables_metadata)
    generate_table_models("views", schema_path, schema.views_metadata)
    generate_enum_models(schema_path, schema.enums_metadata)
  end

  private def generate_table_models(name : String, schema_path : String, tables : Array(Metadata::Table))
    puts "Generating #{name}"

    tables.each do |table|
      FileUtils.mkdir_p(File.join(schema_path, name))
      file_path = File.join(schema_path, name, "#{table.name}.cr")
      FileUtils.touch(file_path)

      table_templ = Templates::TableTemplate.new(name.capitalize, dialect, table)
      File.open(file_path, "w") do |file|
        table_templ.to_s(file)
      end
    end
  end

  private def generate_enum_models(schema_path : String, enums : Array(Metadata::Enum))
    puts "Generating enums"

    enums.each do |enum_metadata|
      FileUtils.mkdir_p(File.join(schema_path, "enums"))
      file_path = File.join(schema_path, "enums", "#{enum_metadata.name}.cr")
      FileUtils.touch(file_path)

      enum_templ = Templates::EnumTemplate.new(dialect, enum_metadata)
      File.open(file_path, "w") do |file|
        enum_templ.to_s(file)
      end
    end
  end
end
