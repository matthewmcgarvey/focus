require "spec"
require "../src/focus"

def formatted(sql : String) : String
  sql.strip.gsub(/\s+/, " ")
end
