require "../test_base"
require "../../src/pg"

abstract class PGTestBase < TestBase
  @database : Stealth::PGDatabase?

  def database : Stealth::PGDatabase
    @database ||= Stealth::PGDatabase.connect("postgres://postgres:postgres@localhost/test")
  end

  def setup
    exec_sql_script("./test/support/init-pg-data.sql")
  end

  def teardown
    exec_sql_script("./test/support/drop-pg-data.sql")
  end
end
