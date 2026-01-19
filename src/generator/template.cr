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

    generate_table_models("table", schema_path, schema.tables_metadata)
    generate_table_models("view", schema_path, schema.views_metadata)
  end

  private def generate_table_models(name : String, schema_path : String, tables : Array(Metadata::Table))
    puts "Generating #{name} models"

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
end
