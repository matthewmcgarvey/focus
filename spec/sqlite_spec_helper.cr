require "./spec_helper"
require "../src/sqlite"
require "./sqlite/gen/table/*"

SQLITE_DATABASE = DB.open("sqlite3://foo.db")

def in_transaction(&)
  SQLITE_DATABASE.transaction do |txn|
    yield txn.connection
    txn.rollback
  end
end

Spec.after_suite do
  SQLITE_DATABASE.close
end
