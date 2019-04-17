require_relative 'file_helper'
require_relative 'billcoiner'
require_relative 'block'
require_relative 'transaction'
require 'flamegraph'

Flamegraph.generate('flamegrapher.html') do
  # no file found in directory
  raise 'No file specified' if ARGV.empty?
  # this object will handle getting info from the file
  file_helper = FileHelper.new(ARGV[0])
  # use this class to avoid ARGV for tests
  billcoiner = BillCoiner.new
  # just gets all of the lines from the file, untouched, so that billcoiner can work with them
  billcoiner.parse_lines(file_helper.file_lines)
end
