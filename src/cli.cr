require "./focus"
require "./sqlite"
require "./generator"
require "option_parser"

parser = OptionParser.parse do |parser|
  parser.on("--help", "-h", "Display help") do
    puts parser
  end

  parser.on("run", "It's gonna do something... eventually") do
    db = DB.open("sqlite3://foo.db")
    template = Focus::Template.dialect(Focus::SQLiteDialect.new)
    generator = Focus::SQLiteGenerator.new(db, "./gen", template)
    generator.generate
  end
end

parser.parse
