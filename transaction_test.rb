require 'minitest/autorun'
require_relative 'transaction'

class TransactionTest < Minitest::Test
	def setup
		Transaction.clear_dictionaries
	end

	def test_dictionary_match
		transaction_string = "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"
		transaction = Transaction::new(transaction_string)
		transaction.add_to_dictionaries
		assert_equal(transaction.current_dictionary,Transaction.overall_dictionary)
	end

	def test_dictionary_key_contents
		transaction_string = "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"
		transaction = Transaction::new(transaction_string)
		transaction.add_to_dictionaries
		assert_equal(transaction.current_dictionary.has_key?("George"),true)
		assert_equal(Transaction.overall_dictionary.has_key?("George"),true)
		assert_equal(transaction.current_dictionary.has_key?("Amina"),true)
		assert_equal(Transaction.overall_dictionary.has_key?("Amina"),true)
		assert_equal(transaction.current_dictionary.has_key?("Henry"),true)
		assert_equal(Transaction.overall_dictionary.has_key?("Henry"),true)
	end

	def test_dictionary_value_contents
		transaction_string = "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"
		transaction = Transaction::new(transaction_string)
		transaction.add_to_dictionaries
		assert_equal(transaction.current_dictionary.has_value?(16),true)
		assert_equal(Transaction.overall_dictionary.has_value?(16),true)
		assert_equal(transaction.current_dictionary.has_value?(4),true)
		assert_equal(Transaction.overall_dictionary.has_value?(4),true)
		assert_equal(transaction.current_dictionary.has_value?(17),true)
		assert_equal(Transaction.overall_dictionary.has_value?(17),true)
	end

	def test_dictionary_negative
		transaction_string = "George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)"
		transaction = Transaction::new(transaction_string)
		transaction.add_to_dictionaries
		assert_equal(Transaction.negatives?,true)
	end

	def test_dictionary_non_negative
		transaction_string = "Celest>Har(80):SYSTEM>Celest(100)"
		transaction = Transaction::new(transaction_string)
		transaction.add_to_dictionaries
		assert_equal(Transaction.negatives?,false)
	end
end