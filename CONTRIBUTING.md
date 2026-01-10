`crystal run src/cli.cr -- run -s postgres -d postgres://postgres:postgres@localhost:5432/test -o test/pg/gen/`

`crystal run src/cli.cr -- run -s sqlite -d sqlite3://foo.db -o test/sqlite/gen/`
