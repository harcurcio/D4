requires 'file-helper.rb'
requires 'billcoiner.rb'

# this object will handle working with the file so the tests don't have to worry about it
file_helper = FileHelper.new ARGV[0]

# this class executes the actual code; all the methods are wrapped in here for easier testing,
# otherwise trying to test verifier.rb itself would execute puts and file opening
billcoiner = BillCoiner.new

# just gets all of the lines from the file, untouched, so that billcoiner can work with them
billcoiner.parse_lines(file_helper.get_file_lines)

# with the blocks filled, now get user info, check for errors, etc.
billcoiner.block_worker

# once all necessary work has been done, print out the user info
billcoiner.puts_users
