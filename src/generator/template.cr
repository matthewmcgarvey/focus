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
    return if schema.empty?

    schema_path = dest_dir

    puts "Destination directory: #{schema_path}"
    puts "Cleaning up destination directory..."

    FileUtils.rm_rf(schema_path)

    generate_table_models(schema_path, schema)
  end

  private def generate_table_models(schema_path : String, schema : Metadata::Schema)
    puts "Generating table models"

    schema.tables_metadata.each do |table|
      FileUtils.mkdir_p(File.join(schema_path, "table"))
      file_path = File.join(schema_path, "table", "#{table.name}.cr")
      FileUtils.touch(file_path)

      table_templ = Templates::TableTemplate.new(table)
      File.open(file_path, "w") do |file|
        table_templ.to_s(file)
      end
    end
  end
end
