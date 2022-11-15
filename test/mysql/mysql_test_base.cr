require "../test_base"
require "../../src/mysql"

abstract class MySqlTestBase < TestBase
  @database : Stealth::MySqlDatabase?

  def database : Stealth::MySqlDatabase
    @database ||= Stealth::MySqlDatabase.connect("mysql://root:password@localhost/test")
  end

  def setup
    exec_sql_script("./test/support/init-mysql-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-mysql-data.sql")
  end
end
