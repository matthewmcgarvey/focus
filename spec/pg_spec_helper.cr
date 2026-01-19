require "./spec_helper"
require "../src/pg"
require "./pg/gen/tables/*"
require "./pg/gen/views/*"
require "./pg/gen/enums/*"

include Tables
include Views
include Enums

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
