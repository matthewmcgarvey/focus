require "minitest"
require "minitest/focus"
require "../src/stealth"
require "./support/tables"

abstract class TestBase < Minitest::Test
  abstract def database : Stealth::Database

  def exec_sql_script(filename : String)
    database.with_connection do |conn|
      raw_sql = File.read(filename)
      raw_sql.split(';')
        .map(&.presence)
        .compact
        .each { |sql_stmt| conn.exec sql_stmt }
    end
  end
end

require "minitest/autorun"
