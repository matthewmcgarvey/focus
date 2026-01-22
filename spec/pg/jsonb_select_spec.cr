require "../pg_spec_helper"

describe "PG JSONB Select" do
  it "selects rows where jsonb contains key-value pair using @>" do
    json_value = JSON.parse(%({"seat": "window"}))
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.contains(Focus::PG.jsonb(json_value)))
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences @> $1 ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Avery", "Nora", "Isla", "Jun"])
  end

  it "selects rows where jsonb is contained by value using <@" do
    json_value = JSON.parse(%({"seat": "aisle", "meal": "standard", "notifications": true}))
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.contained_by(Focus::PG.jsonb(json_value)))
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences <@ $1 ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Theo"])
  end

  it "selects rows where jsonb has specific key using ?" do
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.has_key(Focus::PG.string("loyalty_tier")))
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences ? $1 ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Nora", "Isla", "Jun"])
  end

  it "extracts text value from jsonb using ->>" do
    stmt = Passengers.select(Passengers.preferences.get_text(Focus::PG.string("meal")))
      .where(Passengers.first_name.eq(Focus::PG.string("Avery")))

    stmt.to_sql.should eq(%(SELECT passengers.preferences ->> $1 FROM passengers WHERE passengers.first_name = $2))
    stmt.query_one(PG_DATABASE, as: String).should eq("vegetarian")
  end

  it "extracts jsonb value using ->" do
    stmt = Passengers.select(Passengers.preferences.get(Focus::PG.string("notifications")))
      .where(Passengers.first_name.eq(Focus::PG.string("Avery")))

    stmt.to_sql.should eq(%(SELECT passengers.preferences -> $1 FROM passengers WHERE passengers.first_name = $2))
    # -> returns jsonb, which PG driver returns as JSON::PullParser or string representation
    result = stmt.query_one(PG_DATABASE, as: JSON::Any)
    result.as_bool.should eq(true)
  end

  it "selects rows with null jsonb values using is_null" do
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.is_null)
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences IS NULL ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Miles", "Sophie"])
  end

  it "selects rows with non-null jsonb values using is_not_null" do
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.is_not_null)
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences IS NOT NULL ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Avery", "Lena", "Nora", "Theo", "Isla", "Omar", "Jun"])
  end

  it "filters by multiple jsonb conditions" do
    json_value = JSON.parse(%({"meal": "standard", "notifications": true}))
    stmt = Passengers.select(Passengers.first_name)
      .where(Passengers.preferences.contains(Focus::PG.jsonb(json_value)))
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE passengers.preferences @> $1 ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Theo"])
  end

  it "combines jsonb filter with other column filters using and" do
    json_value = JSON.parse(%({"seat": "window"}))
    stmt = Passengers.select(Passengers.first_name)
      .where(
        Focus::PG.and(
          Passengers.preferences.contains(Focus::PG.jsonb(json_value)),
          Passengers.preferences.has_key(Focus::PG.string("loyalty_tier"))
        )
      )
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name FROM passengers WHERE (passengers.preferences @> $1) AND (passengers.preferences ? $2) ORDER BY passengers.id ASC))
    stmt.query_all(PG_DATABASE, as: String).should eq(["Nora", "Isla", "Jun"])
  end

  it "extracts nested text value with chained -> and ->>" do
    # Get preferences->'loyalty_tier' as text for passengers who have it
    stmt = Passengers.select(Passengers.first_name, Passengers.preferences.get_text(Focus::PG.string("loyalty_tier")))
      .where(Passengers.preferences.has_key(Focus::PG.string("loyalty_tier")))
      .order_by(Passengers.id.asc)

    stmt.to_sql.should eq(%(SELECT passengers.first_name, passengers.preferences ->> $1 FROM passengers WHERE passengers.preferences ? $2 ORDER BY passengers.id ASC))
    result = stmt.query_all(PG_DATABASE, as: {String, String})
    result.should eq([{"Nora", "gold"}, {"Isla", "platinum"}, {"Jun", "silver"}])
  end
end
