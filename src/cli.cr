require "cling"
require "./focus"
require "./pg"
require "./sqlite"
require "./generator"
require "./cli/*"

main = MainCommand.new
main.add_command(RunCommand.new)
main.execute ARGV
