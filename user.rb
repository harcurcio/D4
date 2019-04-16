# stores user info
class User
  attr_reader :id, :billcoins
  def initialize(id, coins)
    @id = id if id.is_a? Integer
    @billcoins = coins if coins.is_a? Integer
  end

  def add_coins(coins)
    @billcoins += coins
  end

  # compares this ID to another's for sorting purposes
  # returns 0 if equal
  # 1 if greater
  # -1 if less than
  def compare_id(to_compare)
    if to_compare.is_a? User
      result = if @id > to_compare.id
                 1
               elsif @id < to_compare.id
                 -1
               else
                 0
               end
    end
    result
  end

  # same as compare id but just for raw int
  def compare_int(to_compare)
    if to_compare.is_a? Integer
      result = if @id > to_compare
                 1
               elsif @id < to_compare
                 -1
               else
                 0
               end
    end
    result
  end

  # returns all info in a string format for puts
  def to_string
    @id.to_s + ': ' + @billcoins.to_s + ' billcoins '
  end
end
