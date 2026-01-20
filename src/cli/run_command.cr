class RunCommand < Cling::Command
  def setup : Nil
    @name = "run"
    @description = "Generates Focus classes from your database"

    add_option 'h', "help", description: "sends help information"
    add_option 's', "source", description: "postgres, sqlite", type: :single, required: true
    add_option 'd', "db", description: "database url", type: :single, required: true
    add_option 'o', "output", description: "output dir", type: :single, default: "./gen"
    add_option "schema", description: "database schema", type: :single, default: "public"
  end

  def pre_run(arguments : Cling::Arguments, options : Cling::Options) : Nil
    if options.has? "help"
      puts help_template # generated using Cling::Formatter
      exit_program 0     # exit code 0 for successful
    end
  end

  def run(arguments : Cling::Arguments, options : Cling::Options) : Nil
    source = options.get("source").as_s
    db_url = options.get("db").as_s
    output_dir = options.get("output").as_s
    schema = options.get("schema").as_s

    case source
    when "postgres"
      generate_pg(db_url: db_url, output_dir: output_dir, schema: schema)
    when "sqlite"
      generate_sqlite(db_url: db_url, output_dir: output_dir)
    else
      stderr.puts "Invalid source '#{source}'"
      exit_program
    end
  end

  private def generate_pg(db_url : String, output_dir : String, schema : String)
    dialect = Focus::PG::Dialect.new
    template = Focus::Template.dialect(dialect)
    generator = Focus::PG::Generator.from_url(
      url: db_url,
      dest_dir: output_dir,
      template: template,
      schema: schema
    )
    generator.generate
  end

  private def generate_sqlite(db_url : String, output_dir : String)
    dialect = Focus::SQLite::Dialect.new
    template = Focus::Template.dialect(dialect)
    generator = Focus::SQLite::Generator.from_url(
      url: db_url,
      dest_dir: output_dir,
      template: template
    )
    generator.generate
  end
end
