require "../executing_test_base"
require "../../src/mysql"

abstract class MySqlTestBase < ExecutingTestBase
  @database : DB::Database?

  def database : DB::Database
    @database ||= DB.open("mysql://root:password@localhost/test")
  end

  def setup
    exec_sql_script("./test/support/init-mysql-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-mysql-data.sql")
  end
end
