require_relative 'transaction'

# Holds all information contained within a line in the file
class Block
  @@total_block_number = -1
  attr_reader :block_number
  attr_reader :prev_hash
  attr_reader :transaction_string
  attr_reader :transactions
  attr_reader :timestamp
  attr_reader :current_hash
  attr_reader :computed_hash

  def initialize(data)
    @block_number       = data[0].to_i
    @prev_hash          = data[1]
    @transaction_string = data[2]
    @transactions       = Transaction.new(@transaction_string)
    @transactions.add_to_dictionaries
    @timestamp          = data[3]
    @current_hash       = data[4].strip
    @computed_hash      = compute_hash
    @@total_block_number += 1
  end

  def compute_hash
    hash_string = "#{@block_number}|#{@prev_hash}|#{@transaction_string}|#{@timestamp}"
    hash = 0
    hash_string.each_char do |x|
      x = x.unpack('U*')[0]
      hash += ((x**3000) + (x**x) - (3**x)) * (7**x)
    end
    (hash % 65_536).to_s(16)
  end

  # Ensures that the hash computed with the formula matches the one found
  # in the file
  def verify_hash
    raise "Line #{total_block_number}: hash was incorrectly calculated" unless @current_hash == @computed_hash

    true
  end

  # Ensures that none of the transactions resulted in a negative balance
  def verify_transactions
    raise "Line #{total_block_number}: transaction resulted in a negative" if Transaction.negatives?

    true
  end

  # Ensures that the hash of the previous block matches the appropriate one
  # in this block
  def verify_prev_hash(prev_block)
    unless prev_block.nil?
      hash = prev_block.computed_hash
      raise "Line #{total_block_number}: previous hash was #{hash}, should be #{@prev_hash}" unless @prev_hash == hash

    end
    true
  end

  # Ensures the current block number matches the total
  def verify_block_num
    unless @block_number == @@total_block_number
      raise "Line #{@@total_block_number}: invalid block number #{@block_number}, should be #{@@total_block_number}"

    end

    true
  end

  # Ensures this block's timestamp is greater than the one before it
  def verify_timestamp(prev_block)
    unless prev_block.nil?
      prev_timestamp = prev_block.timestamp
      prev_seconds = prev_timestamp.split('.')[0].to_i

      curr_seconds = @timestamp.split('.')[0].to_i

      if prev_seconds == curr_seconds
        prev_nano = prev_timestamp.split('.')[1].to_i
        curr_nano = @timestamp.split('.')[1].to_i
        if prev_nano >= curr_nano
          raise "Line #{total_block_number}: Prev timestamp #{prev_timestamp} >= new timestamp #{@timestamp}"
        end
      elsif prev_seconds > curr_seconds
        raise "Line #{total_block_number}: Prev timestamp #{prev_timestamp} >= new timestamp #{@timestamp}"
      end
      true
    end
  end

  def self.total_block_number
    @@total_block_number
  end

  def self.increase_total_block_num
    @@total_block_number += 1
  end

  def print_totals
    @transactions.print_totals
  end
end
