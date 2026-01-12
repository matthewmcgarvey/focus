---
name: focus-sql-review
description: Reviews Focus SQL query builder implementations for correctness and type safety. Use when examining expressions, columns, statements, clauses, SQL generation code, or visitor pattern implementations.
allowed-tools: Read, Grep, Glob
---

# Focus SQL Review

Review SQL query builder code in the Focus library for correctness, type safety, and API consistency.

## When to Use

- Reviewing expression or column implementations
- Analyzing statement builders (SELECT, INSERT, UPDATE, DELETE)
- Checking clause composition
- Validating visitor pattern implementations
- Examining SQL generation logic

## Review Checklist

### 1. Type Safety
- [ ] Generic types used correctly (e.g., `IntColumn(Int32)` vs `IntColumn(Int64)`)
- [ ] Expression hierarchy respected (`IntExpression`, `StringExpression`, `BoolExpression`, `TimeExpression`)
- [ ] Column module included properly in column types
- [ ] Return types match expected expression types

### 2. Visitor Pattern
- [ ] `accept(visitor : SqlVisitor)` implemented correctly
- [ ] Corresponding `visit_*` method exists in SqlFormatter
- [ ] Inner expressions delegated properly via `.try(&.accept(self))`

### 3. SQL Correctness
- [ ] Generated SQL is syntactically valid
- [ ] Parameters bound safely (no SQL injection)
- [ ] Whitespace handling consistent (trailing space convention)
- [ ] Identifier quoting applied when needed

### 4. API Consistency
- [ ] Method naming follows Focus conventions (`eq`, `greater_than`, etc.)
- [ ] Return type is `BoolExpression` for comparison operations
- [ ] Fluent chaining preserved
- [ ] Null handling uses `is_null` / `is_not_null` pattern

### 5. Clause Composition
- [ ] Clauses implement `ordered_clauses` correctly for statements
- [ ] WHERE, HAVING use expression-based conditions
- [ ] SET clause handles both values and subqueries

## Key Patterns Reference

See [patterns.md](./patterns.md) for detailed type hierarchy and implementation patterns.
