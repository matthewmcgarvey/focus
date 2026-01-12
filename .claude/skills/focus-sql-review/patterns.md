# Focus Type Hierarchy & Patterns

## Expression Hierarchy

```
Focus::Expression (abstract)
├── Focus::IntExpression(INT_TYPE)    # Generic for Int32, Int64, etc.
├── Focus::StringExpression
├── Focus::BoolExpression
├── Focus::TimeExpression
├── Focus::AliasedExpression
├── Focus::BinaryExpression
├── Focus::AggregateExpression
├── Focus::FunctionExpression
├── Focus::PostfixOperatorExpression
├── Focus::ValueExpression
└── Focus::WildcardExpression
```

## Column Types

Columns include the `Focus::Column` module and inherit from typed expressions:

```crystal
class Focus::IntColumn(INT_TYPE) < Focus::IntExpression(INT_TYPE)
  include Focus::Column
end

class Focus::StringColumn < Focus::StringExpression
  include Focus::Column
end

class Focus::BoolColumn < Focus::BoolExpression
  include Focus::Column
end

class Focus::TimeColumn < Focus::TimeExpression
  include Focus::Column
end
```

### Usage Examples
```crystal
getter id : Focus::IntColumn(Int32)
getter salary : Focus::IntColumn(Int64)
getter name : Focus::StringColumn
getter is_active : Focus::BoolColumn
getter created_at : Focus::TimeColumn
```

## Literal Types

Each expression type has a corresponding literal:

| Expression | Literal |
|------------|---------|
| `IntExpression(T)` | `IntLiteral(T)` |
| `StringExpression` | `StringLiteral` |
| `BoolExpression` | `BoolLiteral` |
| `TimeExpression` | `TimeLiteral` |

## Table Hierarchy

```
Focus::Table (abstract)
├── Focus::SQLiteTable
└── Focus::PGTable
```

## Statement Types

Each database has its own statement implementations:

```
Focus::SQLite::SelectStatement
Focus::SQLite::InsertStatement
Focus::SQLite::UpdateStatement
Focus::SQLite::DeleteStatement

Focus::PG::SelectStatement
Focus::PG::InsertStatement
Focus::PG::UpdateStatement
Focus::PG::DeleteStatement
```

## Visitor Pattern

### SqlVisitor Methods

```crystal
visit_statement(statement : Statement)
visit_clause(clause : Clause)
visit_expression(expression : Expression)
visit_column(column : Column)
visit_table(table : Table)
visit_token(token : Token)
visit_literal(literal : Parameter)
```

### SqlFormatter Conventions

- Write trailing space after each element: `write "SELECT "`
- Use `wrap_in_parens` for parenthesized expressions
- Use `visit_list` for comma-separated items
- Parameters stored in `@parameters` array
- Use `write_placeholder` for parameter placeholders (`?`)
- Use `write_identifier` for table/column names (handles quoting)

## Comparison Operations

All comparison methods return `Focus::BoolExpression`:

```crystal
column.eq(value)           # =
column.greater_than(value) # >
column.is_null             # IS NULL
column.is_not_null         # IS NOT NULL
column.in_list(...)        # IN (...)
column.not_in_list(...)    # NOT IN (...)
```

## Query Building Pattern

```crystal
# SELECT
table.select(columns).where(condition).limit(10)

# INSERT
table.insert(columns).values(values).exec(db)

# UPDATE
table.update.set(column, value).where(condition).exec(db)

# DELETE
table.delete.where(condition).exec(db)
```
