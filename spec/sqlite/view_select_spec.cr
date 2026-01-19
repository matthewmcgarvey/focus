require "../sqlite_spec_helper"

describe "SQLite view select" do
  it "selects from booking_itineraries view" do
    rows = BookingItineraries
      .select(BookingItineraries.booking_id, BookingItineraries.flight_number)
      .where(BookingItineraries.booking_status.eq(Focus::SQLite.string("confirmed")))
      .order_by(BookingItineraries.booking_id.asc, BookingItineraries.flight_number.asc)
      .query_all(SQLITE_DATABASE, as: {Int32, String})

    rows.should eq([
      {1, "FX100"},
      {4, "FX110"},
      {4, "FX170"},
      {7, "FX140"},
    ])
  end

  it "filters flight_details by status" do
    rows = FlightDetails
      .select(FlightDetails.flight_number)
      .where(FlightDetails.status.eq(Focus::SQLite.string("scheduled")))
      .order_by(FlightDetails.flight_number.asc)
      .query_all(SQLITE_DATABASE, as: String)

    rows.should eq([
      "FX100",
      "FX110",
      "FX120",
      "FX140",
      "FX150",
      "FX160",
      "FX180",
      "FX300",
    ])
  end
end
