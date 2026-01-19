require "./spec_helper"
require "../src/sqlite"
require "./sqlite/gen/tables/*"
require "./sqlite/gen/views/*"

include Tables
include Views

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
