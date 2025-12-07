require "./src/focus"
require "./src/sqlite"
require "./src/generator/**"

db = DB.open("sqlite3://foo.db")
template = Focus::Template.dialect(Focus::SQLiteDialect.new)

generator = Focus::SQLiteGenerator.new(db, "./gen", template)
generator.generate
