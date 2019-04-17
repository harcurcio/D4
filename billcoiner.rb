require_relative 'block'
require_relative 'transaction'
# methods needed to work with billcoin files and such
class BillCoiner
  # goes through all the lines of the file; inits blocks then compares
  def parse_lines(lines)
    prev = nil
    lines.each do |line|
      curr = Block.new(line.split('|'))
      block_verifiers(curr)
      block_compare_verifiers(curr, prev) unless prev.nil?
      prev = curr
    end
    prev.print_totals
  end

  # runs verifiers that only require current block
  def block_verifiers(curr)
    curr.verify_hash
    curr.verify_transactions
    curr.verify_block_num
  end

  # runs verifiers that require 2 blocks
  def block_compare_verifiers(curr, prev)
    curr.verify_prev_hash(prev)
    curr.verify_timestamp(prev)
  end
end
