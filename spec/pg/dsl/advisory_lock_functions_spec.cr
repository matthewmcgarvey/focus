require "../../pg_spec_helper"

describe Focus::PG::Dsl::AdvisoryLockFunctions do
  describe ".pg_advisory_lock" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_lock(Focus::PG.int64(123_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_lock($1)")
      visitor1.parameters.should eq([123_i64])

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_lock(Focus::PG.int32(1), Focus::PG.int32(2)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_lock($1, $2)")
      visitor2.parameters.should eq([1, 2])
    end

    it "acquires lock and unlock returns true" do
      Focus::PG.select(Focus::PG.pg_advisory_lock(Focus::PG.int64(30001_i64))).exec(PG_DATABASE)

      stmt = Focus::PG.select(Focus::PG.pg_advisory_unlock(Focus::PG.int64(30001_i64)).aliased("released"))
      result = stmt.query_one(PG_DATABASE, as: Bool)
      result.should be_true
    end
  end

  describe ".pg_advisory_lock_shared" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_lock_shared(Focus::PG.int64(456_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_lock_shared($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_lock_shared(Focus::PG.int32(3), Focus::PG.int32(4)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_lock_shared($1, $2)")
    end
  end

  describe ".pg_advisory_xact_lock" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_xact_lock(Focus::PG.int64(789_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_xact_lock($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_xact_lock(Focus::PG.int32(5), Focus::PG.int32(6)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_xact_lock($1, $2)")
    end
  end

  describe ".pg_advisory_xact_lock_shared" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_xact_lock_shared(Focus::PG.int64(101_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_xact_lock_shared($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_xact_lock_shared(Focus::PG.int32(7), Focus::PG.int32(8)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_xact_lock_shared($1, $2)")
    end
  end

  describe ".pg_try_advisory_lock" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_lock(Focus::PG.int64(999_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_try_advisory_lock($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_lock(Focus::PG.int32(9), Focus::PG.int32(10)).accept(visitor2)
      visitor2.to_sql.should eq("pg_try_advisory_lock($1, $2)")
    end

    it "returns boolean and can acquire lock" do
      stmt = Focus::PG.select(Focus::PG.pg_try_advisory_lock(Focus::PG.int64(10001_i64)).aliased("acquired"))
      result = stmt.query_one(PG_DATABASE, as: Bool)
      result.should be_true

      Focus::PG.select(Focus::PG.pg_advisory_unlock(Focus::PG.int64(10001_i64))).query_one(PG_DATABASE, as: Bool)
    end
  end

  describe ".pg_try_advisory_lock_shared" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_lock_shared(Focus::PG.int64(888_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_try_advisory_lock_shared($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_lock_shared(Focus::PG.int32(11), Focus::PG.int32(12)).accept(visitor2)
      visitor2.to_sql.should eq("pg_try_advisory_lock_shared($1, $2)")
    end
  end

  describe ".pg_try_advisory_xact_lock" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_xact_lock(Focus::PG.int64(777_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_try_advisory_xact_lock($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_xact_lock(Focus::PG.int32(13), Focus::PG.int32(14)).accept(visitor2)
      visitor2.to_sql.should eq("pg_try_advisory_xact_lock($1, $2)")
    end

    it "returns boolean and lock is released after transaction" do
      in_transaction do |conn|
        stmt = Focus::PG.select(Focus::PG.pg_try_advisory_xact_lock(Focus::PG.int64(20001_i64)).aliased("acquired"))
        result = stmt.query_one(conn, as: Bool)
        result.should be_true
      end
    end
  end

  describe ".pg_try_advisory_xact_lock_shared" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_xact_lock_shared(Focus::PG.int64(666_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_try_advisory_xact_lock_shared($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_try_advisory_xact_lock_shared(Focus::PG.int32(15), Focus::PG.int32(16)).accept(visitor2)
      visitor2.to_sql.should eq("pg_try_advisory_xact_lock_shared($1, $2)")
    end
  end

  describe ".pg_advisory_unlock" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_unlock(Focus::PG.int64(555_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_unlock($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_unlock(Focus::PG.int32(17), Focus::PG.int32(18)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_unlock($1, $2)")
    end

    it "returns false when lock was not held" do
      stmt = Focus::PG.select(Focus::PG.pg_advisory_unlock(Focus::PG.int64(99999_i64)).aliased("released"))
      result = stmt.query_one(PG_DATABASE, as: Bool)
      result.should be_false
    end
  end

  describe ".pg_advisory_unlock_shared" do
    it "renders function call for both overloads" do
      visitor1 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_unlock_shared(Focus::PG.int64(444_i64)).accept(visitor1)
      visitor1.to_sql.should eq("pg_advisory_unlock_shared($1)")

      visitor2 = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_unlock_shared(Focus::PG.int32(19), Focus::PG.int32(20)).accept(visitor2)
      visitor2.to_sql.should eq("pg_advisory_unlock_shared($1, $2)")
    end
  end

  describe ".pg_advisory_unlock_all" do
    it "renders function call" do
      visitor = Focus::PG::Formatter.new
      Focus::PG.pg_advisory_unlock_all.accept(visitor)
      visitor.to_sql.should eq("pg_advisory_unlock_all()")
    end
  end
end
