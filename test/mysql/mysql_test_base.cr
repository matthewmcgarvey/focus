require "../test_base"
require "../../src/mysql"

abstract class MySqlTestBase < TestBase
  @database : Focus::MySqlDatabase?

  def database : Focus::MySqlDatabase
    @database ||= Focus::MySqlDatabase.connect("mysql://root:password@localhost/test")
  end

  def setup
    exec_sql_script("./test/support/init-mysql-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-mysql-data.sql")
  end
end
