require "../executing_test_base"
require "../../src/pg"
require "../../gen/table/*"

abstract class PGTestBase < ExecutingTestBase
  @database : DB::Database?

  def database : DB::Database
    @database ||= DB.open("postgres://postgres:postgres@localhost/test")
  end

  def setup
    exec_sql_script("./test/support/init-pg-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-pg-data.sql")
  end
end
