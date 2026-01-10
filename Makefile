.PHONY: test test-focus test-pg test-sqlite gen-pg gen-sqlite gen-all

test: test-focus test-sqlite test-pg

test-focus:
	crystal spec spec/focus/

test-pg:
	crystal spec spec/pg/

test-sqlite:
	crystal spec spec/sqlite/

gen-pg:
	crystal run src/cli.cr -- run -s postgres -d postgres://postgres:postgres@localhost:5432/test -o spec/pg/gen/

gen-sqlite:
	crystal run src/cli.cr -- run -s sqlite -d sqlite3://foo.db -o spec/sqlite/gen/

gen-all: gen-pg gen-sqlite
