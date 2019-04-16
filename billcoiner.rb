requires 'block.rb'
requires 'transaction.rb'
requires 'user.rb'
# methods needed to work with billcoin files and such
class BillCoiner
  attr_reader :users
  def initializer
    @users = []
    @blocks = []
  end

  # goes through all the file lines (strings) and creates blocks.
  # this can be refactored by putting all functionality of block_worker
  # here as reading the lines. instead of saving array of blocks, just
  # hold on to previous and current block to check hash and time. plus
  # can just check for other formatting errors along the way.
  # will still need to keep users array
  def parse_lines(lines)
    lines.each do |line|                # for all lines:
      @blocks.push(create_block(line))  # add blocks to the array given a line
    end
  end

  # takes a string to convert into a block
  def create_block(line)
    # splits by delimiter |
    segments = line.split('|')
    # block:  line #,      prev hash,   transactions,                 time,                     curr hash
    Block.new(segments[0], segments[1], create_transacs(segments[2]), create_time(segments[3]), segments[4])
  end

  # creates an array of transactions for a block
  def create_transacs(transacs)
    splitted = []
    # splits each transaction
    strings = transacs.split(':')
    # turns each transaction string into an object
    strings.each do |transac|
      splitted.push(create_transac(transac))
    end
    splitted
  end

  # creates a single transaction object given a pre-split string from whole list
  def create_transac(transac)
    # splits each individual transaction
    temp = transac.split(':')
    # if it's from SYSTEM, don't try to cast as int
    temp[0] = temp[0].to_i unless temp[0] == 'SYSTEM'
    # split the second id from the coin amnt
    second = temp[1].split('(')
    # if SYSTEM, do same as above
    second[0] = second[0].to_i unless second[0] == 'SYSTEM'
    # remove the end parenthesis and cast as int
    amnt = second[1].chomp(')').to_i
    # return new Transaction
    Transaction.new(temp[0], second[0], amnt)
  end

  # creates time unit to be placed in block using string
  def create_time(time)
    times = time.split('.')
    Time.new(times[0], times[1])
  end

  # goes through all of the blocks to check for errors and create users where needed
  def block_worker
    prev = nil
    @blocks.each do |block|
      check_block(prev, block)
      prev = block
    end
  end

  # works with a block and its variables
  def check_block(prev, curr)
    # if there's a block to compare to
    compare_blocks(prev, curr) unless prev.nil?
    curr.transactions.each do |transac|
      update_user(transac)
    end
    # TODO
  end

  # will create a new user if one doesn't exist within a transac, otherwise updates
  def update_user(transac)
    # search for the sending party and take coins
    id = transac.idFrom
    if id != 'SYSTEM'
      user = search_user(id)
      # if user wasn't found add new one
      add_user(id, 0) if user.nil?
      # since the coins should be leaving this acct, subtract
      user.add_coins(-transac.coins)
    end
    # now search for the receiving party and add them
    id = transac.idTo
    if id != 'SYSTEM'
      user = search_user(id)
      # if user wasn't found add new one
      add_user(id, 0) if user.nil?
      # no negative since coins entering this
      user.add_coins(transac.coins)
    end
  end

  # searches @user for matching id, returns user object if match is found
  def search_user(id)
    i = 0
    user = nil
    # since array should be sorted, if this id > one in array it dne
    while i < @users.length && @users[i].id <= id
      # if id exists, update
      user = @users[i] if id == @users[i].id
    end
    user
  end

  # adds a user and then sorts after adding
  def add_user(id, coins)
    if id != 'SYSTEM'
      @users.push(User.new(id, coins))
      @users.sort_by(&:id)
    end
  end

  # makes sure time and hash line up between curr and prev blocks
  # this assumes there are methods specific to comparing time and hash
  def compare_blocks(prev, curr)
    # TODO
  end
  
  # will print out all user info line by line
  def puts_users
    @users.each do |user|
      puts user.to_string
    end
  end

  # using a specific code, will raise an error based on it
  # and will show the user where things went wrong
  # this will help with tests by mocking a different functionality
  def raiser(code, block)
    #TODO
    
    puts 'BLOCKCHAIN INVALID'
    exit(1)
  end
end
