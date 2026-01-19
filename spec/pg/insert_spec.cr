require "../pg_spec_helper"

describe "PG Insert" do
  it "inserts with simple values" do
    in_transaction do |conn|
      ids = Departments.insert(Departments.name, Departments.location)
        .values("r&d", "basement")
        .values("hr", "hawaii")
        .returning(Departments.id)
        .query_all(conn, as: Int32)
      ids.size.should eq(2)

      result = Departments.select(Departments.name).query_all(conn, String)
      result.should eq(["tech", "finance", "r&d", "hr"])
    end
  end

  it "inserts from query" do
    in_transaction do |conn|
      Departments.insert(Departments.name, Departments.location)
        .query(
          Departments.select(Departments.name, Departments.location)
            .where(Departments.id.eq(Focus::PG.int32(1))))
        .exec(conn)

      result = Departments.select(Focus::PG.count(Departments.id)).where(Departments.name.eq(Focus::PG.string("tech"))).query_one(conn, Int64)
      result.should eq(2)
    end
  end

  it "inserts booking with booked_at as now() - 7 days" do
    in_transaction do |conn|
      seven_days_ago = Focus::PG.now.sub(Focus::PG.interval("7 days"))

      id = Bookings.insert(Bookings.passenger_id, Bookings.booked_at, Bookings.total_amount, Bookings.status)
        .values(1, seven_days_ago, 100.0, "pending")
        .returning(Bookings.id)
        .query_one(conn, Int32)

      # Verify the booking was created with a timestamp approximately 7 days ago
      result = Bookings.select(Bookings.booked_at)
        .where(Bookings.id.eq(Focus::PG.int32(id)))
        .query_one(conn, Time)

      expected_time = Time.utc - 7.days
      # Allow 1 minute tolerance for test execution time
      (result - expected_time).abs.should be < 1.minute
    end
  end

  it "inserts passenger with jsonb preferences" do
    in_transaction do |conn|
      preferences = JSON.parse(%({"seat": "window", "meal": "vegan", "notifications": true}))

      stmt = Passengers.insert(Passengers.first_name, Passengers.last_name, Passengers.email, Passengers.birth_date, Passengers.preferences)
        .values("Test", "User", "test@example.com", Focus::PG.date(1990, 1, 1), Focus::PG.jsonb(preferences))
        .returning(Passengers.id)

      stmt.to_sql.should eq(%(INSERT INTO passengers (first_name, last_name, email, birth_date, preferences) VALUES ($1, $2, $3, CAST($4 AS DATE), $5) RETURNING passengers.id))

      id = stmt.query_one(conn, Int32)

      # Verify the passenger was created with the correct jsonb preferences
      result = Passengers.select(Passengers.preferences.get_text(Focus::PG.string("meal")))
        .where(Passengers.id.eq(Focus::PG.int32(id)))
        .query_one(conn, String)

      result.should eq("vegan")

      # Verify containment query works on inserted data
      contains_result = Passengers.select(Passengers.first_name)
        .where(Passengers.preferences.contains(Focus::PG.jsonb(JSON.parse(%({"seat": "window"})))))
        .where(Passengers.id.eq(Focus::PG.int32(id)))
        .query_one(conn, String)

      contains_result.should eq("Test")
    end
  end

  it "inserts ticket with generated uuid" do
    in_transaction do |conn|
      stmt = Tickets.insert(Tickets.booking_id, Tickets.passenger_id, Tickets.issued_at, Tickets.status, Tickets.is_refundable, Tickets.uuid)
        .values(1, 1, Focus::PG.timestamp(2024, 3, 20, 12, 15, 0), "issued", true, Focus::PG.gen_random_uuid)
        .returning(Tickets.id)

      stmt.to_sql.should eq(%(INSERT INTO tickets (booking_id, passenger_id, issued_at, status, is_refundable, uuid) VALUES ($1, $2, CAST($3 AS TIMESTAMP), $4, $5, gen_random_uuid()) RETURNING tickets.id))

      id = stmt.query_one(conn, Int32)

      stmt = Tickets.select(Tickets.status)
        .where(Tickets.id.eq(Focus::PG.int32(id)))

      result = stmt.query_one(conn, String)
      result.should eq("issued")
    end
  end
end
