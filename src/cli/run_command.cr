class RunCommand < Cling::Command
  def setup : Nil
    @name = "run"
    @description = "Generates Focus classes from your database"

    add_option 'h', "help", description: "sends help information"
    add_option 's', "source", description: "postgres, sqlite, mysql", type: :single, required: true
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

    dialect = case source
              when "postgres"
                Focus::PGDialect.new
              when "sqlite"
                Focus::SQLiteDialect.new
              when "mysql"
                Focus::MySqlDialect.new
              else
                stderr.puts "Invalid source '#{source}'"
                exit_program
              end
    db = DB.open(db_url)
    template = Focus::Template.dialect(dialect)
    generator = case dialect
                when Focus::PGDialect
                  Focus::PGGenerator.new(db.not_nil!, output_dir, template, schema)
                when Focus::SQLiteDialect
                  Focus::SQLiteGenerator.new(db.not_nil!, output_dir, template, schema)
                when Focus::MySqlDialect
                  Focus::MySqlGenerator.new(db.not_nil!, output_dir, template, schema)
                else
                  stderr.puts "Error: unknown dialect #{dialect.class}"
                  exit_program
                end
    generator.generate
  end
end
