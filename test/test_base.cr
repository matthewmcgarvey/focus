require "minitest"
require "minitest/focus"
require "../src/focus"
# require "./support/tables/*"

abstract class TestBase < Minitest::Test
  def formatted(sql : String) : String
    sql.strip.gsub(/\s+/, " ")
  end
end

require "minitest/autorun"
