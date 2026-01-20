require "./spec_helper"
require "../src/pg"
require "./pg/gen/test/public/**"
require "./pg/gen/test/inventory/**"

include Gen::Test::Public::Tables
include Gen::Test::Public::Views
include Gen::Test::Public::Enums
include Gen::Test::Inventory::Tables

PG_DATABASE = DB.open("postgres://postgres:postgres@localhost/test")

def in_transaction(&)
  PG_DATABASE.transaction do |txn|
    yield txn.connection
    txn.rollback
  end
end

Spec.after_suite do
  PG_DATABASE.close
end
