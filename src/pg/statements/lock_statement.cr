class Focus::PG::LockStatement < Focus::Statement
  include Focus::PG::Statement
  enum LockMode
    ACCESS_SHARE
    ROW_SHARE
    ROW_EXCLUSIVE
    SHARE_UPDATE_EXCLUSIVE
    SHARE
    SHARE_ROW_EXCLUSIVE
    EXCLUSIVE
    ACCESS_EXCLUSIVE
  end

  getter table : Focus::ReadableTable
  getter! lock_mode : LockMode
  getter? no_wait : Bool

  def initialize(@table : Focus::ReadableTable)
    @no_wait = false
  end

  def in_access_share : self
    @lock_mode = LockMode::ACCESS_SHARE
    self
  end

  def in_row_share : self
    @lock_mode = LockMode::ROW_SHARE
    self
  end

  def in_row_exclusive : self
    @lock_mode = LockMode::ROW_EXCLUSIVE
    self
  end

  def in_share_update_exclusive : self
    @lock_mode = LockMode::SHARE_UPDATE_EXCLUSIVE
    self
  end

  def in_share : self
    @lock_mode = LockMode::SHARE
    self
  end

  def in_share_row_exclusive : self
    @lock_mode = LockMode::SHARE_ROW_EXCLUSIVE
    self
  end

  def in_exclusive : self
    @lock_mode = LockMode::EXCLUSIVE
    self
  end

  def in_access_exclusive : self
    @lock_mode = LockMode::ACCESS_EXCLUSIVE
    self
  end

  def no_wait : self
    @no_wait = true
    self
  end

  def statement_type : Focus::SqlFormatter::StatementType
    Focus::SqlFormatter::StatementType::LOCK_STMT_TYPE
  end

  def ordered_clauses : Array(Focus::Clause)
    raise "this shouldn't be called"
  end
end
