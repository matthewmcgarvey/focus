require "../sqlite_spec_helper"

class Employee
  include DB::Serializable

  property id : Int32
  property name : String
  property job : String
  property manager_id : Int32?
  property hire_date : Time
  property salary : Int32
  property department_id : Int32
  property is_remote : Bool
end

class Department
  include DB::Serializable

  property id : Int32
  property name : String
  property location : String
  @[DB::Field(key: "mixedCase")]
  property mixed_case : String?
end

describe "SQLite Select" do
  it "passes sql and arguments to database" do
    stmt1 = Departments.select(Departments.id)
    sql1, args1 = stmt1.to_sql_with_args
    result1 = SQLITE_DATABASE.query_all(sql1, args: args1, as: Int32)
    result1.should eq([1, 2])

    stm2 = Employees.select(Focus.count(Employees.id)).where(Employees.salary.greater_than(60))
    sql2, args2 = stm2.to_sql_with_args
    result2 = SQLITE_DATABASE.query_one(sql2, args: args2, as: Int32)
    result2.should eq(3)
  end

  it "query_all returns all matching rows" do
    stmt1 = Employees.select(Employees.id, Employees.name)
    result1 = stmt1.query_all(SQLITE_DATABASE, as: {id: Int32, name: String})
    result1.should eq([
      {id: 1, name: "vince"},
      {id: 2, name: "marry"},
      {id: 3, name: "tom"},
      {id: 4, name: "penny"},
    ])

    stmt2 = Departments.select(Departments.name, Departments.location)
    result2 = stmt2.query_all(SQLITE_DATABASE, as: {String, String})
    result2.should eq([
      {"tech", "Guangzhou"},
      {"finance", "Beijing"},
    ])

    stmt3 = Employees.select.order_by(Employees.id.asc).limit(2)
    result3 = stmt3.query_all(SQLITE_DATABASE, as: Employee)
    result3.map(&.name).should eq(["vince", "marry"])
  end

  it "query_one returns single row" do
    stmt1 = Employees.select(Employees.name).where(Employees.id.eq(2))
    result1 = stmt1.query_one(SQLITE_DATABASE, as: String)
    result1.should eq("marry")

    stmt2 = Departments.select.where(Departments.id.eq(1))
    result2 = stmt2.query_one(SQLITE_DATABASE, as: Department)
    result2.name.should eq("tech")

    stmt3 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(3))
    result3 = stmt3.query_one(SQLITE_DATABASE, as: {id: Int32, name: String})
    result3.should eq({id: 3, name: "tom"})

    stmt4 = Departments.select(Departments.name, Departments.location).where(Departments.id.eq(2))
    result4 = stmt4.query_one(SQLITE_DATABASE, as: {String, String})
    result4.should eq({"finance", "Beijing"})
  end

  it "query_one? returns nil when no rows match" do
    stmt1 = Employees.select(Employees.name).where(Employees.id.eq(5))
    result1 = stmt1.query_one?(SQLITE_DATABASE, as: String)
    result1.should be_nil

    stmt2 = Departments.select.where(Departments.id.eq(3))
    result2 = stmt2.query_one?(SQLITE_DATABASE, as: Department)
    result2.should be_nil

    stmt3 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(6))
    result3 = stmt3.query_one?(SQLITE_DATABASE, as: {id: Int32, name: String})
    result3.should be_nil

    stmt4 = Departments.select(Departments.name, Departments.location).where(Departments.id.eq(4))
    result4 = stmt4.query_one?(SQLITE_DATABASE, as: {String, String})
    result4.should be_nil

    stmt5 = Employees.select(Employees.name).where(Employees.id.eq(2))
    stmt5.query_one?(SQLITE_DATABASE, as: String).should eq("marry")
    stmt5.query_one?(SQLITE_DATABASE, as: {name: String}).should eq({name: "marry"})

    stmt6 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(2))
    stmt6.query_one?(SQLITE_DATABASE, as: {Int32, String}).should eq({2, "marry"})
  end

  it "selects distinct values" do
    dept_ids = Employees.select(Employees.department_id)
      .distinct
      .order_by(Employees.department_id.asc)
      .query_all(SQLITE_DATABASE, Int32)

    dept_ids.should eq([1, 2])
  end

  it "cross joins tables" do
    stmt = Focus::SQLite.select.from(
      Employees.cross_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    stmt.to_sql.should eq("SELECT * FROM employees CROSS JOIN departments ON employees.department_id = departments.id")
  end

  it "inner joins tables" do
    stmt = Focus::SQLite.select.from(
      Employees.inner_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    stmt.to_sql.should eq("SELECT * FROM employees INNER JOIN departments ON employees.department_id = departments.id")
  end

  it "left joins tables" do
    stmt = Focus::SQLite.select.from(
      Employees.left_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    stmt.to_sql.should eq("SELECT * FROM employees LEFT JOIN departments ON employees.department_id = departments.id")
  end

  it "right joins tables" do
    stmt = Focus::SQLite.select.from(
      Employees.right_join(Departments, on: Employees.department_id.eq(Departments.id))
    )

    stmt.to_sql.should eq("SELECT * FROM employees RIGHT JOIN departments ON employees.department_id = departments.id")
  end

  it "uses subselect in where clause" do
    subquery = Employees.select(Employees.department_id).where(Employees.salary.greater_than(90))

    departments = Departments.select
      .where(Departments.id.in_list(subquery))
      .order_by(Departments.id.asc)

    expected_sql = formatted(<<-SQL)
      SELECT * FROM departments WHERE departments.id IN
      (SELECT employees.department_id FROM employees WHERE employees.salary > ?)
      ORDER BY departments.id ASC
    SQL
    departments.to_sql.should eq(expected_sql)
  end

  it "uses table alias" do
    aliased_table = Employees.aliased("e")
    sql = Focus::SQLite.select(aliased_table.name)
      .from(aliased_table)
      .where(aliased_table.salary.greater_than(80))
      .order_by(aliased_table.id.asc)

    expected_sql = formatted(<<-SQL)
      SELECT e.name FROM employees e
      WHERE e.salary > ?
      ORDER BY e.id ASC
    SQL
    sql.to_sql.should eq(expected_sql)
  end

  it "uses subselect in from clause" do
    employee_count_col = Focus::IntColumn(Int32).new("employee_count")
    subquery = Employees.select(Employees.department_id, Focus.count(Employees.id).aliased("employee_count"))
      .group_by(Employees.department_id)
      .having(employee_count_col.greater_than(1))
      .aliased("dept_counts")

    query = Focus::SQLite.select.from(subquery).order_by(employee_count_col.from(subquery).desc)

    expected_sql = formatted(<<-SQL)
      SELECT * FROM
      (SELECT employees.department_id, COUNT(employees.id) AS employee_count
        FROM employees
        GROUP BY employees.department_id
        HAVING employee_count > ?) dept_counts
      ORDER BY dept_counts.employee_count DESC
    SQL
    query.to_sql.should eq(expected_sql)
  end

  it "query with all table columns" do
    query = Departments.select(Departments.columns)
    names = [] of String
    SQLITE_DATABASE.query_all(query.to_sql) do |rs|
      rs.read(Int32)
      names << rs.read(String)
    end

    names.should eq(["tech", "finance"])
  end
end
