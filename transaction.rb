# Holds all information regarding transactions and users
class Transaction
  @@overall_dictionary = {}
  @@bad_key
  @@bad_value
  attr_reader :current_dictionary
  attr_reader :current_transactions

  def initialize(transaction_string)
    @current_dictionary = {}
    @current_transactions = parse_transaction(transaction_string)
  end

  def add_to_dictionaries
    @current_transactions.each do |transaction|
      names = transaction.split('>')
      # first name is before > symbol, so no need to modify
      first_person = names[0]
      # second name has the transaction amount attached to it, like Gaozu(100)
      second_person = names[1].slice(0, names[1].index('('))
      # check that the naming convention is appropriately formatted
      name_format?(first_person)
      name_format?(second_person)
      # remove parantheses and convert to integer
      amount = names[1].split('(')[1].tr('()', '').to_i
      # We take from the first person
      if first_person != 'SYSTEM'
        if @current_dictionary.key?(first_person)
          @current_dictionary[first_person] -= amount
        else
          @current_dictionary.store(first_person, 0 - amount)
        end
      end
      # and give it to the second person
      if @current_dictionary.key?(second_person)
        @current_dictionary[second_person] += amount
      else
        @current_dictionary.store(second_person, amount)
      end
    end
    # update the entire dictionary with new users/info
    @current_dictionary.each do |key, value|
      if @@overall_dictionary.key?(key)
        @@overall_dictionary[key] += value
      else
        @@overall_dictionary.store(key, value)
      end
    end
  end

  # splits the entire string by the ':' delimiter
  def parse_transaction(transaction_string)
    transaction_string.split(':')
  end

  # makes sure that a person's name is appropriate format
  def name_format?(person)
    raise "#{person}'s name is not at least 6 letters" if person == 'SYSTEM' && (person =~ /^[A-z]{1,6}$/).nil?
    raise "#{person}'s name is not at least 6 letters" if person != 'SYSTEM' && (person =~ /^[0-9]{1,6}$/).nil?

    true
  end

  # checks if any values turned out negative
  def self.negatives?
    @@overall_dictionary.each do |key, value|
      if value < 0
        @@bad_key = key
        @@bad_value = value
        return true
      end
    end
    false
  end

  # self means same thing as static.  This method is
  # called on the class, not an instance of the class
  # i.e: Transaction.print_totals, not curr_transaction.print_totals
  def print_totals
    @@overall_dictionary.sort.each do |key, value|
      puts "#{key}: #{value} billcoins"
    end
  end

  def self.bad_key
    @@bad_key
  end

  def self.bad_value
    @@bad_value
  end

  def self.overall_dictionary
    @@overall_dictionary
  end

  def self.clear_dictionaries
    @@overall_dictionary.clear
    @current_dictionary = {}
    @current_dictionary.clear
  end
end
