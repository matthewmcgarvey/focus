require "../executing_test_base"
require "../../src/sqlite"
require "./gen/table/*"

abstract class SQLiteTestBase < ExecutingTestBase
  @database : DB::Database?

  def database : DB::Database
    @database ||= DB.open("sqlite3://foo.db")
  end

  def setup
    # exec_sql_script("./test/support/init-sqlite-data.sql")
  end

  def teardown
    # exec_sql_script("./test/support/drop-sqlite-data.sql")
  end
end
