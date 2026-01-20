module Focus::PG::Dsl::AdvisoryLockFunctions
  # Session-level exclusive advisory lock
  def pg_advisory_lock(key : Focus::IntExpression(Int64)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_lock", parameters: [key] of Focus::Expression)
  end

  def pg_advisory_lock(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_lock", parameters: [key1, key2] of Focus::Expression)
  end

  # Session-level shared advisory lock
  def pg_advisory_lock_shared(key : Focus::IntExpression(Int64)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_lock_shared", parameters: [key] of Focus::Expression)
  end

  def pg_advisory_lock_shared(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_lock_shared", parameters: [key1, key2] of Focus::Expression)
  end

  # Transaction-level exclusive advisory lock
  def pg_advisory_xact_lock(key : Focus::IntExpression(Int64)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_xact_lock", parameters: [key] of Focus::Expression)
  end

  def pg_advisory_xact_lock(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_xact_lock", parameters: [key1, key2] of Focus::Expression)
  end

  # Transaction-level shared advisory lock
  def pg_advisory_xact_lock_shared(key : Focus::IntExpression(Int64)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_xact_lock_shared", parameters: [key] of Focus::Expression)
  end

  def pg_advisory_xact_lock_shared(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_xact_lock_shared", parameters: [key1, key2] of Focus::Expression)
  end

  # Try to acquire session-level exclusive advisory lock
  def pg_try_advisory_lock(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_lock", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_try_advisory_lock(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_lock", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Try to acquire session-level shared advisory lock
  def pg_try_advisory_lock_shared(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_lock_shared", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_try_advisory_lock_shared(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_lock_shared", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Try to acquire transaction-level exclusive advisory lock
  def pg_try_advisory_xact_lock(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_xact_lock", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_try_advisory_xact_lock(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_xact_lock", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Try to acquire transaction-level shared advisory lock
  def pg_try_advisory_xact_lock_shared(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_xact_lock_shared", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_try_advisory_xact_lock_shared(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_try_advisory_xact_lock_shared", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Release session-level exclusive advisory lock
  def pg_advisory_unlock(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_advisory_unlock", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_advisory_unlock(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_advisory_unlock", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Release session-level shared advisory lock
  def pg_advisory_unlock_shared(key : Focus::IntExpression(Int64)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_advisory_unlock_shared", parameters: [key] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  def pg_advisory_unlock_shared(key1 : Focus::IntExpression(Int32), key2 : Focus::IntExpression(Int32)) : Focus::BoolExpression
    func = Focus::FunctionExpression.new("pg_advisory_unlock_shared", parameters: [key1, key2] of Focus::Expression)
    Focus::BoolExpression.new(func)
  end

  # Release all session-level advisory locks
  def pg_advisory_unlock_all : Focus::FunctionExpression
    Focus::FunctionExpression.new("pg_advisory_unlock_all", parameters: [] of Focus::Expression)
  end
end
