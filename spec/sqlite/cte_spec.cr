require "../sqlite_spec_helper"

describe "common table expressions" do
  it "works" do
    cte = Employees.select(Employees.id, Employees.name).as_cte("managers")
    cte_manager_id = Employees.id.from(cte)
    cte_manager_name = Employees.name.from(cte).aliased("manager_name")
    query = Focus::SQLite.with(cte).statement(
      Employees.join(cte, on: cte_manager_id.eq(Employees.manager_id)).select(Employees.name, cte_manager_name)
    )

    expected_sql = <<-SQL
      WITH managers AS
        (SELECT employees.id, employees.name FROM employees)
      SELECT employees.name, managers.name AS manager_name
      FROM employees
      INNER JOIN managers ON (managers.id = employees.manager_id)
    SQL
    query.to_sql.should eq(formatted(expected_sql))
    results = query.query_all(SQLITE_DATABASE, {String, String})
    results.should eq([{"marry", "vince"}, {"penny", "tom"}])
  end
end
