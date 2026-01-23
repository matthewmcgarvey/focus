require "../sqlite_spec_helper"

describe Focus::TokenFormatter do
  describe "produces identical SQL to SqlFormatter" do
    it "simple SELECT" do
      stmt = Employees.select(Employees.id, Employees.name)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "SELECT with WHERE" do
      stmt = Employees.select(Employees.id).where(Employees.id.eq(Focus::SQLite.int32(1)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "complex WHERE with AND" do
      stmt = Employees.select(Employees.id).where(Employees.id.eq(Focus::SQLite.int32(1)).and(Employees.id.eq(Focus::SQLite.int32(2))))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "complex WHERE with OR" do
      stmt = Employees.select(Employees.id).where(Employees.id.eq(Focus::SQLite.int32(1)).or(Employees.id.eq(Focus::SQLite.int32(2))))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "nested boolean expressions" do
      stmt = Employees.select(Employees.id).where(
        Employees.id.eq(Focus::SQLite.int32(1)).and(Employees.id.eq(Focus::SQLite.int32(2))).or(Employees.id.eq(Focus::SQLite.int32(3)))
      )
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "INNER JOIN" do
      stmt = Employees.inner_join(Departments, on: Employees.department_id.eq(Departments.id))
        .select(Employees.name, Departments.name)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "LEFT JOIN" do
      stmt = Employees.left_join(Departments, on: Employees.department_id.eq(Departments.id))
        .select(Employees.name, Departments.name)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "multiple JOINs" do
      managers = Employees.aliased("managers")
      stmt = Employees
        .inner_join(Departments, on: Employees.department_id.eq(Departments.id))
        .left_join(managers, on: Employees.manager_id.eq(managers.id))
        .select(Employees.name)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "ORDER BY" do
      stmt = Employees.select(Employees.id).order_by(Employees.name.asc)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "ORDER BY with NULLS" do
      stmt = Employees.select(Employees.id).order_by(Employees.name.asc.nulls_first)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "GROUP BY" do
      stmt = Employees.select(Employees.department_id).group_by(Employees.department_id)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "GROUP BY with HAVING" do
      stmt = Employees.select(Employees.department_id)
        .group_by(Employees.department_id)
        .having(Focus::SQLite.count(Employees.id).greater_than(Focus::SQLite.int32(1)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "LIMIT" do
      stmt = Employees.select(Employees.id).limit(10)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "LIMIT and OFFSET" do
      stmt = Employees.select(Employees.id).limit(10).offset(20)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "INSERT single row" do
      stmt = Employees.insert(Employees.name, Employees.job).values("John", "Dev")
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "INSERT multiple rows" do
      stmt = Employees.insert(Employees.name, Employees.job)
        .values("John", "Dev")
        .values("Jane", "Manager")
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "UPDATE" do
      stmt = Employees.update.set(Employees.name, "Jane").where(Employees.id.eq(Focus::SQLite.int32(1)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "UPDATE multiple columns" do
      stmt = Employees.update
        .set(Employees.name, "Jane")
        .set(Employees.job, "Manager")
        .where(Employees.id.eq(Focus::SQLite.int32(1)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "DELETE" do
      stmt = Employees.delete.where(Employees.id.eq(Focus::SQLite.int32(1)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "SELECT with alias" do
      stmt = Employees.select(Employees.name.aliased("employee_name"))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "subquery in FROM" do
      employee_count_col = Focus::SQLite.int32_column("employee_count")
      subquery = Employees.select(Employees.department_id, Focus::SQLite.count(Employees.id).aliased("employee_count"))
        .group_by(Employees.department_id)
        .aliased("dept_counts")

      stmt = Focus::SQLite.select.from(subquery).order_by(employee_count_col.from(subquery).desc)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "BETWEEN" do
      stmt = Employees.select(Employees.id).where(Employees.id.between(Focus::SQLite.int32(1), Focus::SQLite.int32(10)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "NOT BETWEEN" do
      stmt = Employees.select(Employees.id).where(Employees.id.not_between(Focus::SQLite.int32(1), Focus::SQLite.int32(10)))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "IS NULL" do
      stmt = Employees.select(Employees.id).where(Employees.manager_id.is_null)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "IS NOT NULL" do
      stmt = Employees.select(Employees.id).where(Employees.manager_id.is_not_null)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "LIKE" do
      stmt = Employees.select(Employees.id).where(Employees.name.like(Focus::SQLite.string("%John%")))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "IN subquery" do
      subquery = Employees.select(Employees.department_id).where(Employees.salary.greater_than(Focus::SQLite.int32(90)))
      stmt = Departments.select.where(Departments.id.in_list(subquery))
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "aggregate functions" do
      stmt = Employees.select(
        Focus::SQLite.count(Employees.id),
        Focus::SQLite.sum(Employees.id),
        Focus::SQLite.avg(Employees.id),
        Focus::SQLite.min(Employees.id),
        Focus::SQLite.max(Employees.id)
      )
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "CAST expression" do
      stmt = Employees.select(Focus::SQLite.cast(Employees.id).as_text)
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "DISTINCT" do
      stmt = Employees.select(Employees.department_id).distinct
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

    it "wildcard SELECT" do
      stmt = Employees.select
      stmt.to_sql_via_tokens.should eq stmt.to_sql
    end

  end

  describe "parameters match" do
    it "WHERE with parameters" do
      stmt = Employees.select(Employees.id).where(Employees.id.eq(Focus::SQLite.int32(42)))
      old_sql, old_params = stmt.to_sql_with_args
      new_sql, new_params = stmt.to_sql_via_tokens_with_args
      new_sql.should eq old_sql
      new_params.should eq old_params
    end

    it "INSERT with parameters" do
      stmt = Employees.insert(Employees.name, Employees.job).values("John", "Dev")
      old_sql, old_params = stmt.to_sql_with_args
      new_sql, new_params = stmt.to_sql_via_tokens_with_args
      new_sql.should eq old_sql
      new_params.should eq old_params
    end

    it "UPDATE with parameters" do
      stmt = Employees.update.set(Employees.name, "Jane").where(Employees.id.eq(Focus::SQLite.int32(1)))
      old_sql, old_params = stmt.to_sql_with_args
      new_sql, new_params = stmt.to_sql_via_tokens_with_args
      new_sql.should eq old_sql
      new_params.should eq old_params
    end

    it "LIMIT and OFFSET with parameters" do
      stmt = Employees.select(Employees.id).limit(10).offset(20)
      old_sql, old_params = stmt.to_sql_with_args
      new_sql, new_params = stmt.to_sql_via_tokens_with_args
      new_sql.should eq old_sql
      new_params.should eq old_params
    end
  end

  describe "to_tokens returns token list" do
    it "returns array of tokens" do
      stmt = Employees.select(Employees.id)
      tokens = stmt.to_tokens
      tokens.should be_a(Array(Focus::Sql::Token))
      tokens.should_not be_empty
    end

    it "contains expected token types for SELECT" do
      stmt = Employees.select(Employees.id)
      tokens = stmt.to_tokens
      tokens.any? { |t| t.is_a?(Focus::Sql::Keyword) && t.as(Focus::Sql::Keyword).text == "SELECT" }.should be_true
      tokens.any? { |t| t.is_a?(Focus::Sql::Keyword) && t.as(Focus::Sql::Keyword).text == "FROM" }.should be_true
      tokens.any? { |t| t.is_a?(Focus::Sql::Identifier) }.should be_true
    end
  end
end
