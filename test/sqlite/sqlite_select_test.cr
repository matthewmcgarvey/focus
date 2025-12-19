require "./sqlite_test_base"

class SQLiteSelectTest < SQLiteTestBase
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

  def test_passing_sql_and_arguments_to_database
    stmt1 = Departments.select(Departments.id)
    sql1, args1 = stmt1.to_sql_with_args
    result1 = database.query_all(sql1, args: args1, as: Int32)
    assert_equal [1, 2], result1

    stm2 = Employees.select(Focus.count(Employees.id)).where(Employees.salary.greater_than(60))
    sql2, args2 = stm2.to_sql_with_args
    result2 = database.query_one(sql2, args: args2, as: Int32)
    assert_equal 3, result2
  end

  def test_query_all
    stmt1 = Employees.select(Employees.id, Employees.name)
    result1 = stmt1.query_all(database, as: {id: Int32, name: String})
    assert_equal [
      {id: 1, name: "vince"},
      {id: 2, name: "marry"},
      {id: 3, name: "tom"},
      {id: 4, name: "penny"},
    ], result1

    stmt2 = Departments.select(Departments.name, Departments.location)
    result2 = stmt2.query_all(database, as: {String, String})
    assert_equal [
      {"tech", "Guangzhou"},
      {"finance", "Beijing"},
    ], result2

    stmt3 = Employees.select.order_by(Employees.id.asc).limit(2)
    result3 = stmt3.query_all(database, as: Employee)
    assert_equal ["vince", "marry"], result3.map(&.name)
  end

  def test_query_one
    stmt1 = Employees.select(Employees.name).where(Employees.id.eq(2))
    result1 = stmt1.query_one(database, as: String)
    assert_equal "marry", result1

    stmt2 = Departments.select.where(Departments.id.eq(1))
    result2 = stmt2.query_one(database, as: Department)
    assert_equal "tech", result2.name

    stmt3 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(3))
    result3 = stmt3.query_one(database, as: {id: Int32, name: String})
    assert_equal({id: 3, name: "tom"}, result3)

    stmt4 = Departments.select(Departments.name, Departments.location).where(Departments.id.eq(2))
    result4 = stmt4.query_one(database, as: {String, String})
    assert_equal({"finance", "Beijing"}, result4)
  end

  def test_query_one?
    stmt1 = Employees.select(Employees.name).where(Employees.id.eq(5))
    result1 = stmt1.query_one?(database, as: String)
    assert_nil result1

    stmt2 = Departments.select.where(Departments.id.eq(3))
    result2 = stmt2.query_one?(database, as: Department)
    assert_nil result2

    stmt3 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(6))
    result3 = stmt3.query_one?(database, as: {id: Int32, name: String})
    assert_nil result3

    stmt4 = Departments.select(Departments.name, Departments.location).where(Departments.id.eq(4))
    result4 = stmt4.query_one?(database, as: {String, String})
    assert_nil result4

    stmt5 = Employees.select(Employees.name).where(Employees.id.eq(2))
    assert_equal "marry", stmt5.query_one?(database, as: String)
    assert_equal({name: "marry"}, stmt5.query_one?(database, as: {name: String}))

    stmt6 = Employees.select(Employees.id, Employees.name).where(Employees.id.eq(2))
    assert_equal({2, "marry"}, stmt6.query_one?(database, as: {Int32, String}))
  end
end
