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
end
