require "./spec_helper"
require "../src/sqlite"
require "./sqlite/gen/test/**"

include Gen::Test::Tables
include Gen::Test::Views

SQLITE_DATABASE = DB.open("sqlite3://spec/support/test.db")

def in_transaction(&)
  SQLITE_DATABASE.transaction do |txn|
    yield txn.connection
    txn.rollback
  end
end

Spec.after_suite do
  SQLITE_DATABASE.close
end
