# AGENTS.md - Focus SQL Query Builder

## Project Overview

Focus is a Crystal SQL query builder for multiple databases, inspired by Kotlin's Ktorm.
Key design principle: **separate data models from database tables** - tables build queries,
results bind to any `DB::Serializable` struct/class.

**Language:** Crystal 1.18.0
**Project Type:** Library (shard) for SQL query building

## Build & Development Commands

### Install Dependencies
```bash
shards install
```

### Run All Tests
```bash
make test
```

### Run a Single Spec File
```bash
crystal spec spec/pg/select_spec.cr
```

### Run Specs for a Database
```bash
crystal spec spec/sqlite/
crystal spec spec/pg/
```

### Run Linter (Ameba)
```bash
./bin/ameba
```

### Build CLI
```bash
shards build
# or
crystal build src/cli.cr
```

### Generate Table Code from Schema
```bash
make gen-sqlite    # Generate SQLite tables
make gen-pg        # Generate PostgreSQL tables
make gen-all       # Generate both
```

## Project Structure

```
src/
├── focus.cr              # Main library entry point
├── cli.cr                # CLI entry point
├── cli/                  # CLI commands
├── focus/                # Core library
│   ├── clauses/          # SQL clause types (SELECT, FROM, WHERE, etc.)
│   ├── columns/          # Column types (Int32Column, StringColumn, etc.)
│   ├── dsl/              # DSL helpers (aggregation functions)
│   ├── expressions/      # SQL expression types
│   ├── tokens/           # SQL tokens
│   └── visitors/         # Visitor pattern (SqlFormatter)
├── generator/            # Table code generator
│   ├── pg/               # PostgreSQL schema introspection
│   ├── sqlite/           # SQLite schema introspection
│   └── templates/        # Code generation templates
├── sqlite/               # SQLite-specific code
│   ├── sqlite_table.cr   # SQLiteTable class
│   └── statements/       # SQLite statement builders (SELECT, INSERT, etc.)
├── pg/                   # PostgreSQL-specific code
│   ├── pg_table.cr       # PGTable class
│   └── statements/       # PostgreSQL statement builders

spec/
├── spec_helper.cr        # Base spec helper
├── pg_spec_helper.cr     # PostgreSQL spec helper with database connection
├── sqlite_spec_helper.cr # SQLite spec helper with database connection
├── pg/                   # PostgreSQL integration specs
│   ├── gen/table/        # Generated PostgreSQL table definitions
│   ├── select_spec.cr
│   ├── insert_spec.cr
│   ├── update_spec.cr
│   └── delete_spec.cr
├── sqlite/               # SQLite integration specs
│   ├── gen/table/        # Generated SQLite table definitions
│   ├── select_spec.cr
│   ├── insert_spec.cr
│   ├── update_spec.cr
│   └── delete_spec.cr
└── support/              # SQL scripts (init-*.sql, drop-*.sql)
```

## Code Style Guidelines

### Formatting
- **Indentation:** 2 spaces (no tabs)
- **Line endings:** LF
- **Encoding:** UTF-8
- **Trailing newline:** Required
- **Trailing whitespace:** Not allowed

### Naming Conventions
- `snake_case` for methods and variables
- `PascalCase` for types, classes, modules
- Table classes: `{Name}Table` suffix (e.g., `EmployeesTable`)
- Table instances: Constant without suffix (e.g., `Employees = EmployeesTable.new`)
- Column classes: `{Type}Column` (e.g., `Int32Column`, `StringColumn`)
- Spec files: `*_spec.cr`

### Imports/Requires
- Standard library first, then dependencies, then local files
- Use relative paths for local requires: `require "../test_base"`
- Wildcard requires for directories: `require "./focus/*"`
- Order within focus.cr shows proper require ordering for dependencies

### Types & Type Annotations
- Use Crystal's type inference where possible
- Explicit return types on public methods
- Nilable types with `?` suffix: `String?`
- Use `getter` macro for read-only properties
- Use `property` for read-write properties

### Classes & Inheritance
- Use `abstract class` for base classes that shouldn't be instantiated
- Inherit from `Focus::Table` for new table types
- Inherit from `Focus::Column` for new column types
- Inherit from `Focus::Expression` for new expression types

### Error Handling
- Use Crystal's `raise` for runtime errors
- Macro `{% raise %}` for compile-time errors on type mismatches
- Return `nil` for "not found" cases (e.g., `query_one?`)

### Testing Conventions
- Test framework: Crystal's built-in Spec
- Use `describe` blocks for grouping, `it` blocks for individual tests
- Use `actual.should eq(expected)` for equality checks
- Use `value.should be_nil` for nil checks
- Helper method `formatted(sql)` strips and normalizes whitespace in SQL strings
- Use `in_transaction` helper for tests that modify data (auto-rollback)

### Table Definition Pattern
```crystal
class UsersTable < Focus::SQLiteTable  # or Focus::PgTable
  getter id : Focus::Int32Column
  getter name : Focus::StringColumn

  def initialize(table_name : String = "users", table_alias : String? = nil)
    @id = Focus::Int32Column.new("id", table_name)
    @name = Focus::StringColumn.new("name", table_name)
    columns = [@id, @name]
    super(table_name, table_alias, columns)
  end
end

Users = UsersTable.new
```

### Query Building Pattern
```crystal
# SELECT
Users.select(Users.name).where(Users.id.eq(1))

# INSERT
Users.insert(Users.name).values("alice").exec(database)

# UPDATE
Users.update.set(Users.name, "bob").where(Users.id.eq(1)).exec(database)

# DELETE
Users.delete.where(Users.id.eq(1)).exec(database)
```

### Visitor Pattern
- SQL generation uses the visitor pattern
- `SqlFormatter` is the main visitor for SQL string generation
- Override `visit_expression`, `visit_clause`, `visit_statement` for custom types
- All expressions implement `accept(visitor : SqlVisitor)`

## Dependencies

**Runtime:**
- `db` (crystal-db) - Database abstraction

**Development:**
- `sqlite3`, `pg` - Database drivers
- `ameba` - Static code analyzer (linter)

## Design Principles

1. **Minimal macros** - Only `column` macro exists; avoid magic
2. **Separate models from tables** - Tables build queries, not represent data
3. **Multi-database support** - SQLite, PostgreSQL
4. **Type safety** - Leverage Crystal's type system
5. **Composable queries** - Chain methods fluently
