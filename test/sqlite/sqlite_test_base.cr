require "../test_base"
require "../../src/sqlite"

abstract class SQLiteTestBase < TestBase
  @database : Stealth::SQLiteDatabase?

  def database : Stealth::SQLiteDatabase
    @database ||= Stealth::SQLiteDatabase.connect("sqlite3://%3Amemory%3A")
  end

  def setup
    exec_sql_script("./test/support/init-sqlite-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-sqlite-data.sql")
  end
end
