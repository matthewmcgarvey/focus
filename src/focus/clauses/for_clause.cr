class Focus::ForClause < Focus::Clause
  enum LockStrength
    Update
    NoKeyUpdate
    Share
    KeyShare
  end

  enum WaitPolicy
    Nowait
    SkipLocked
  end

  getter strength : LockStrength
  getter wait_policy : WaitPolicy?
  getter tables : Array(Focus::Table)?

  def initialize(
    @strength : LockStrength,
    @wait_policy : WaitPolicy? = nil,
    @tables : Array(Focus::Table)? = nil,
  )
  end
end
