require "../test_base"
require "../../src/sqlite"

abstract class SQLiteTestBase < TestBase
  @database : Focus::SQLiteDatabase?

  def database : Focus::SQLiteDatabase
    @database ||= Focus::SQLiteDatabase.connect("sqlite3://")
  end

  def setup
    exec_sql_script("./test/support/init-sqlite-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-sqlite-data.sql")
  end
end
