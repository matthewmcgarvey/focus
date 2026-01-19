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

### Run Unit Tests Only
```bash
make test-focus
```

### Run a Single Spec File
```bash
crystal spec spec/pg/select_spec.cr
```

### Run Specs for a Database
```bash
make test-sqlite   # or: crystal spec spec/sqlite/
make test-pg       # or: crystal spec spec/pg/
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
├── cli.cr                # CLI entry point (uses cling framework)
├── sqlite.cr             # SQLite module entry point (Focus::SQLite)
├── pg.cr                 # PostgreSQL module entry point (Focus::PG)
├── cli/                  # CLI commands
│   ├── main_command.cr   # MainCommand class
│   └── run_command.cr    # RunCommand class for code generation
├── focus/                # Core library
│   ├── clause.cr
│   ├── column.cr         # Column module
│   ├── common_table_expression.cr  # CTE support
│   ├── dialect.cr        # Dialect abstract class
│   ├── expression.cr     # Expression abstract base class
│   ├── join_table.cr
│   ├── parameter.cr
│   ├── queryable.cr      # Queryable module (query methods)
│   ├── readable_table.cr # ReadableTable module (join methods)
│   ├── select_table.cr
│   ├── serializable_table.cr
│   ├── sql_builder.cr
│   ├── sql_visitor.cr    # SqlVisitor abstract class
│   ├── statement.cr      # Statement abstract class
│   ├── table.cr          # Table abstract base class
│   ├── token.cr
│   ├── updateable_table.cr
│   ├── clauses/          # SQL clause types (16 types)
│   │   ├── delete_clause.cr
│   │   ├── from_clause.cr
│   │   ├── group_by_clause.cr
│   │   ├── having_clause.cr
│   │   ├── insert_clause.cr
│   │   ├── limit_clause.cr
│   │   ├── offset_clause.cr
│   │   ├── order_by_clause.cr
│   │   ├── order_by_list_clause.cr
│   │   ├── query_clause.cr
│   │   ├── returning_clause.cr
│   │   ├── select_clause.cr
│   │   ├── set_clause.cr
│   │   ├── update_clause.cr
│   │   ├── values_clause.cr
│   │   └── where_clause.cr
│   ├── columns/          # Column types (5 types)
│   │   ├── bool_column.cr
│   │   ├── float_column.cr
│   │   ├── int_column.cr
│   │   ├── string_column.cr
│   │   └── time_column.cr
│   ├── dsl/              # DSL helpers
│   │   ├── aggregation.cr  # count, sum, avg, min, max
│   │   ├── columns.cr      # int32_column, string_column, etc.
│   │   └── types.cr        # int32, string, bool, etc. literal helpers
│   ├── expressions/      # SQL expression types (22 types)
│   │   ├── aggregate_expression.cr
│   │   ├── aliased_expression.cr
│   │   ├── between_operator_expression.cr
│   │   ├── binary_expression.cr
│   │   ├── bool_expression.cr
│   │   ├── bool_literal.cr
│   │   ├── cast_expression.cr
│   │   ├── column_reference_expression.cr
│   │   ├── float_expression.cr
│   │   ├── float_literal.cr
│   │   ├── function_expression.cr
│   │   ├── int_expression.cr
│   │   ├── int_literal.cr
│   │   ├── null_literal.cr
│   │   ├── numeric_expression.cr
│   │   ├── postfix_operator_expression.cr
│   │   ├── string_expression.cr
│   │   ├── string_literal.cr
│   │   ├── time_expression.cr
│   │   ├── time_literal.cr
│   │   ├── value_expression.cr
│   │   └── wildcard_expression.cr
│   ├── statements/       # Base statement types (5 types)
│   │   ├── delete_statement.cr
│   │   ├── insert_statement.cr
│   │   ├── select_statement.cr
│   │   ├── update_statement.cr
│   │   └── with_statement.cr
│   ├── tokens/
│   │   └── column_token.cr
│   └── visitors/
│       └── sql_formatter.cr  # Main SQL visitor implementation
├── generator/            # Table code generator
│   ├── query_set.cr      # Base query set
│   ├── template.cr       # Template processor
│   ├── metadata/         # Schema metadata types
│   │   ├── column.cr
│   │   ├── schema.cr
│   │   └── table.cr
│   ├── pg/               # PostgreSQL schema introspection
│   │   ├── generator.cr
│   │   └── query_set.cr
│   ├── sqlite/           # SQLite schema introspection
│   │   ├── generator.cr
│   │   └── query_set.cr
│   └── templates/        # Code generation templates
│       ├── table_template.cr
│       └── table_template.ecr
├── sqlite/               # SQLite-specific code
│   ├── readable_table.cr
│   ├── sqlite_dialect.cr
│   ├── sqlite_formatter.cr
│   ├── sqlite_table.cr   # SQLiteTable class
│   ├── statement.cr
│   └── statements/       # SQLite statement builders
│       ├── delete_statement.cr
│       ├── insert_statement.cr
│       ├── select_statement.cr
│       ├── update_statement.cr
│       └── with_statement.cr
├── pg/                   # PostgreSQL-specific code
│   ├── i_like.cr         # iLIKE expression support
│   ├── insert_returning_expression.cr
│   ├── pg_dialect.cr
│   ├── pg_formatter.cr
│   ├── pg_table.cr       # PGTable class
│   ├── readable_table.cr
│   ├── statement.cr
│   └── statements/       # PostgreSQL statement builders
│       ├── delete_statement.cr
│       ├── insert_statement.cr
│       ├── select_statement.cr
│       ├── update_statement.cr
│       └── with_statement.cr

examples/
├── pg.cr                 # PostgreSQL example usage
└── sqlite.cr             # SQLite example usage

spec/
├── spec_helper.cr        # Base spec helper
├── pg_spec_helper.cr     # PostgreSQL spec helper with database connection
├── sqlite_spec_helper.cr # SQLite spec helper with database connection
├── focus/                # Unit tests for focus module
│   ├── column_spec.cr
│   └── columns/
│       └── string_column_spec.cr
├── pg/                   # PostgreSQL integration specs
│   ├── gen/table/        # Generated PostgreSQL table definitions
│   │   ├── departments.cr
│   │   └── employees.cr
│   ├── cte_spec.cr       # Common Table Expression tests
│   ├── select_spec.cr
│   ├── insert_spec.cr
│   ├── update_spec.cr
│   └── delete_spec.cr
├── sqlite/               # SQLite integration specs
│   ├── gen/table/        # Generated SQLite table definitions
│   │   ├── departments.cr
│   │   └── employees.cr
│   ├── cte_spec.cr       # Common Table Expression tests
│   ├── select_spec.cr
│   ├── insert_spec.cr
│   ├── update_spec.cr
│   └── delete_spec.cr
└── support/              # SQL scripts
    ├── drop-pg-data.sql
    ├── drop-sqlite-data.sql
    ├── init-pg-data.sql
    └── init-sqlite-data.sql
```

## Key Classes and Modules

| Class/Module | Location | Description |
|--------------|----------|-------------|
| `Focus` | `src/focus.cr` | Main module, defines VERSION and DBConn alias |
| `Focus::Table` | `src/focus/table.cr` | Abstract base class for tables |
| `Focus::SQLite::Table` | `src/sqlite/sqlite_table.cr` | SQLite table class |
| `Focus::PG::Table` | `src/pg/pg_table.cr` | PostgreSQL table class |
| `Focus::Expression` | `src/focus/expression.cr` | Abstract base for all expressions |
| `Focus::Column` | `src/focus/column.cr` | Module included by column types |
| `Focus::Statement` | `src/focus/statement.cr` | Abstract base for statements |
| `Focus::Queryable` | `src/focus/queryable.cr` | Module with query methods |
| `Focus::ReadableTable` | `src/focus/readable_table.cr` | Module with join methods |
| `Focus::SqlFormatter` | `src/focus/visitors/sql_formatter.cr` | Main SQL visitor |
| `Focus::SQLite` | `src/sqlite.cr` | SQLite module with DSL methods |
| `Focus::PG` | `src/pg.cr` | PostgreSQL module with DSL methods |

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
- Column classes: `{Type}Column` (e.g., `IntColumn`, `StringColumn`, `BoolColumn`, `FloatColumn`, `TimeColumn`)
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
- Include `Focus::Column` module for new column types
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
class UsersTable < Focus::SQLite::Table  # or Focus::PG::Table
  getter id : Focus::IntColumn(Int32)
  getter name : Focus::StringColumn

  def initialize(table_name : String = "users", table_alias : String? = nil)
    @id = Focus::IntColumn(Int32).new("id", table_name)
    @name = Focus::StringColumn.new("name", table_name)
    columns = [@id, @name].select(Focus::Expression)
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

# Common Table Expression (CTE)
Users.with(
  cte_name: "active_users",
  cte_query: Users.select(Users.id).where(Users.active.eq(true))
).select(Users.name)
```

### Visitor Pattern
- SQL generation uses the visitor pattern
- `SqlFormatter` is the main visitor for SQL string generation
- Each database has its own formatter (`SQLite::Formatter`, `PG::Formatter`)
- Override `visit_expression`, `visit_clause`, `visit_statement` for custom types
- All expressions implement `accept(visitor : SqlVisitor)`

### Dialect Pattern
- Each database has a dialect class (`SQLite::Dialect`, `PG::Dialect`)
- Dialects provide the appropriate formatter for SQL generation
- Database-specific features (e.g., `iLIKE` for PostgreSQL) are in dialect modules

## Dependencies

**Runtime:**
- `db` (crystal-lang/crystal-db) ~> 0.13.0 - Database abstraction
- `cling` (devnote-dev/cling) - CLI framework

**Development:**
- `sqlite3` (crystal-lang/crystal-sqlite3) - SQLite driver
- `pg` (will/crystal-pg) 0.29.0 - PostgreSQL driver
- `ameba` (crystal-ameba/ameba) - Static code analyzer (linter)

## Design Principles

1. **Minimal macros** - Only `column` macro exists; avoid magic
2. **Separate models from tables** - Tables build queries, not represent data
3. **Multi-database support** - SQLite, PostgreSQL
4. **Type safety** - Leverage Crystal's type system
5. **Composable queries** - Chain methods fluently
