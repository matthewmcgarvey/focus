require "../sqlite_spec_helper"

describe Focus::SQLite::SetStatement do
  context "#union" do
    it "works" do
      query = Departments.select(Departments.name).where(Departments.name.eq(Focus::SQLite.string("tech")))
        .union(Departments.select(Departments.name).where(Departments.name.eq(Focus::SQLite.string("finance"))))
      query.to_sql.should eq(formatted(<<-SQL))
        SELECT departments.name FROM departments WHERE departments.name = ?
        UNION
        SELECT departments.name FROM departments WHERE departments.name = ?
      SQL
      names = query.query_all(SQLITE_DATABASE, as: String)
      names.sort.should eq(["tech", "finance"].sort)
    end

    it "can have order, limit, and offset set" do
      query = Departments.select(Departments.name).where(Departments.name.eq(Focus::SQLite.string("tech")))
        .union(Departments.select(Departments.name).where(Departments.name.eq(Focus::SQLite.string("finance"))))
        .order_by(Focus::SQLite.string_column("name").desc)
        .limit(1)
        .offset(1)
      query.to_sql.should eq(formatted(<<-SQL))
        SELECT departments.name FROM departments WHERE departments.name = ?
        UNION
        SELECT departments.name FROM departments WHERE departments.name = ?
        ORDER BY name DESC
        LIMIT ?
        OFFSET ?
      SQL
      names = query.query_all(SQLITE_DATABASE, as: String)
      names.should eq(["finance"])
    end
  end

  context "#union_all" do
    it "works" do
      query = Departments.select(Departments.name)
        .union_all(Departments.select(Departments.name))
      query.to_sql.should eq(formatted(<<-SQL))
        SELECT departments.name FROM departments
        UNION ALL
        SELECT departments.name FROM departments
      SQL
      names = query.query_all(SQLITE_DATABASE, as: String)
      names.sort.should eq(["tech", "finance", "tech", "finance"].sort)
    end
  end

  context "#intersect" do
    it "works" do
      query = Flights.join(Aircrafts, on: Aircrafts.id.eq(Flights.aircraft_id))
        .select(Aircrafts.tail_number)
        .where(Flights.status.eq(Focus::SQLite.string("delayed")))
        .intersect(
          Flights.join(Aircrafts, on: Aircrafts.id.eq(Flights.aircraft_id))
            .select(Aircrafts.tail_number)
            .where(Flights.status.eq(Focus::SQLite.string("scheduled")))
        )

      sql, args = query.to_sql_with_args
      sql.should eq(formatted(<<-SQL))
        SELECT aircrafts.tail_number
        FROM flights
        INNER JOIN aircrafts ON aircrafts.id = flights.aircraft_id
        WHERE flights.status = ?
        INTERSECT
        SELECT aircrafts.tail_number
        FROM flights
        INNER JOIN aircrafts ON aircrafts.id = flights.aircraft_id
        WHERE flights.status = ?
      SQL
      args.should eq(["delayed", "scheduled"])
      tail_numbers = query.query_all(SQLITE_DATABASE, as: String)
      tail_numbers.sort.should eq(["N404FX", "N202FX"].sort)
    end
  end

  context "#except" do
    it "works" do
      query = Employees.select(Employees.id)
        .where(Employees.manager_id.is_null)
        .except(
          Employees.select(Employees.id)
            .where(Employees.salary.greater_than(Focus::SQLite.int32(150)))
        )
      query.to_sql.should eq(formatted(<<-SQL))
        SELECT employees.id
        FROM employees
        WHERE employees.manager_id IS NULL
        EXCEPT
        SELECT employees.id
        FROM employees
        WHERE employees.salary > ?
      SQL
      ids = query.query_all(SQLITE_DATABASE, as: Int32)
      ids.should eq([1])
    end
  end
end
