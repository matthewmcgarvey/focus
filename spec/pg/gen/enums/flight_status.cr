module Enums
  enum FlightStatus
    Cancelled
    Delayed
    Scheduled

    def to_expression : Focus::StringExpression
      case self
      when Cancelled
        Focus::PG.string("cancelled")
      when Delayed
        Focus::PG.string("delayed")
      when Scheduled
        Focus::PG.string("scheduled")
      else
        raise "unreachable"
      end
    end
  end
end
