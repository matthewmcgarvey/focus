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
./bin/test
```

### Run a Single Test File
```bash
./bin/test ./test/focus/select_test.cr
```

### Run Tests Matching Pattern
```bash
./bin/test ./test/sqlite/*_test.cr
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
crystal run test.cr
# or via CLI
focus run -d sqlite3://db.db
```

## Project Structure

```
src/
├── focus.cr              # Main library entry point
├── cli.cr                # CLI entry point
├── focus/                # Core library
│   ├── clauses/          # SQL clause types (SELECT, FROM, WHERE, etc.)
│   ├── columns/          # Column types (Int32Column, StringColumn, etc.)
│   ├── dsl/              # DSL helpers
│   ├── expressions/      # SQL expression types
│   ├── statements/       # Statement builders (SELECT, INSERT, UPDATE, DELETE)
│   ├── tokens/           # SQL tokens
│   └── visitors/         # Visitor pattern (SqlFormatter)
├── generator/            # Table code generator
├── sqlite/               # SQLite-specific code
├── pg/                   # PostgreSQL-specific code

test/
├── test_base.cr          # Base class for all tests
├── executing_test_base.cr # Base for tests that execute SQL
├── focus/                # Core library tests
├── sqlite/               # SQLite integration tests
├── pg/                   # PostgreSQL integration tests
└── support/              # Test helpers, SQL scripts, table definitions

gen/table/                # Generated table files
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
- Test classes: `{Feature}Test` (e.g., `FocusSelectTest`)
- Test files: `*_test.cr`

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
- Test framework: minitest.cr
- Test classes extend `TestBase` (unit) or `ExecutingTestBase` (integration)
- Test method names: `def test_descriptive_name`
- Use `assert_equal expected, actual`
- Use `assert_nil` for nil checks
- Helper method `formatted(sql)` strips and normalizes whitespace in SQL strings

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
- `minitest` - Testing framework
- `ameba` - Static code analyzer (linter)

## Design Principles

1. **Minimal macros** - Only `column` macro exists; avoid magic
2. **Separate models from tables** - Tables build queries, not represent data
3. **Multi-database support** - SQLite, PostgreSQL
4. **Type safety** - Leverage Crystal's type system
5. **Composable queries** - Chain methods fluently
