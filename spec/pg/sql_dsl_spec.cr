require "../pg_spec_helper"

describe "Focus::PG.sql DSL" do
  it "allows calling DSL methods without Focus::PG prefix" do
    stmt = Focus::PG.sql do
      Passengers.select(Passengers.first_name)
        .where(Passengers.id.eq(int32(1)))
    end

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE (passengers.id = $1)))
    stmt.query_one(PG_DATABASE, as: String).should eq("Avery")
  end

  it "allows using string literals without prefix" do
    stmt = Focus::PG.sql do
      Passengers.select(Passengers.first_name)
        .where(Passengers.first_name.eq(string("Avery")))
    end

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE (passengers.first_name = $1)))
    stmt.query_one(PG_DATABASE, as: String).should eq("Avery")
  end

  it "allows using jsonb without prefix" do
    stmt = Focus::PG.sql do
      json_value = JSON.parse(%({"seat": "window"}))
      Passengers.select(Passengers.first_name)
        .where(Passengers.preferences.contains(jsonb(json_value)))
        .order_by(Passengers.id.asc)
    end

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE (passengers.preferences @> $1) ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Avery", "Nora", "Isla", "Jun"])
  end

  it "allows using aggregation functions without prefix" do
    stmt = Focus::PG.sql do
      Passengers.select(count(Passengers.id))
    end

    stmt.to_sql.should eq(%(SELECT COUNT(passengers.id) FROM passengers))
    stmt.query_one(PG_DATABASE, as: Int64).should eq(9)
  end

  it "allows using cast without prefix" do
    stmt = Focus::PG.sql do
      Passengers.select(Passengers.first_name)
        .where(Passengers.id.eq(cast(string("1")).as_integer))
    end

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE (passengers.id = CAST($1 AS INTEGER))))
    stmt.query_one(PG_DATABASE, as: String).should eq("Avery")
  end
end
