require "./focus"
require "./sqlite"
require "./generator"
require "option_parser"

parser = OptionParser.parse do |parser|
  parser.on("--help", "-h", "Display help") do
    puts parser
  end

  parser.on("run", "It's gonna do something... eventually") do
    parser.banner = "Usage: focus run -d [URL]"
    parser.on("-d URL", "--db=URL", "Database URL") do |db_url|
      db = DB.open(db_url)
      template = Focus::Template.dialect(Focus::SQLiteDialect.new)
      generator = Focus::SQLiteGenerator.new(db, "./gen", template)
      generator.generate
    end
  end
end

parser.parse
