require 'minitest/autorun'
require 'minitest/mock'
require_relative 'block'

class BlockTest < Minitest::Test
    def test_compute_hash
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        assert_equal block.compute_hash, block.current_hash
    end

    def test_compute_hash_2
        data = ["8", "e01d", "Sam>John(3):Joe>Sam(4):SYSTEM>Rana(100)", "1518839370.605237540", "c87b"]
        block = Block::new(data)
        assert_equal block.compute_hash, block.current_hash
    end

    def test_verify_hash_bad
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c13"]
        block = Block::new(data)

        assert_raises RuntimeError do
            block.verify_hash
        end
    end

    def test_verify_hash_good
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        assert_equal block.verify_hash, true
    end

    def test_verify_transactions_bad
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        def Transaction.negatives?; true; end

        assert_raises RuntimeError do
            block.verify_transactions
        end
    end

    def test_verify_transactions_good
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        def Transaction.negatives?; false; end

        assert_equal block.verify_transactions, true
    end

    def test_prev_hash_nil
        prev_block = nil

        data = ["6", "c675", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_equal block.verify_prev_hash(prev_block), true
    end

    def test_prev_hash_good
        prev_data = ["5", "a38a", "Edward>Amina(1):Tang>Louis(1):SYSTEM>Cyrus(100)", "1518893687.373710000", "c675"]
        prev_block = Block::new(prev_data)

        data = ["6", "c675", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_equal block.verify_prev_hash(prev_block), true
    end

    def test_prev_hash_bad
        prev_data = ["5", "a38a", "Edward>Amina(1):Tang>Louis(1):SYSTEM>Cyrus(100)", "1518893687.373710000", "c675"]
        prev_block = Block::new(prev_data)

        data = ["6", "c674", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_raises RuntimeError do
            block.verify_prev_hash(prev_block)
        end
    end

    def test_verify_block_num_good
        data = ["0", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        assert_equal block.verify_block_num, true
    end

    def test_verify_block_num_bad
        data = ["1", "0", "SYSTEM>Henry(100)", "1518892051.737141000", "1c12"]
        block = Block::new(data)

        assert_raises RuntimeError do
            block.verify_block_num
        end
    end

    def test_verify_timestamp_seconds_greater
        prev_data = ["5", "a38a", "Edward>Amina(1):Tang>Louis(1):SYSTEM>Cyrus(100)", "1518893688.373710000", "c675"]
        prev_block = Block::new(prev_data)

        data = ["6", "c674", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_raises RuntimeError do
            block.verify_timestamp(prev_block)
        end
    end

    def test_verify_timestamp_nanoseconds_greater
        prev_data = ["5", "a38a", "Edward>Amina(1):Tang>Louis(1):SYSTEM>Cyrus(100)", "1518893687.400000000", "c675"]
        prev_block = Block::new(prev_data)

        data = ["6", "c674", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_raises RuntimeError do
            block.verify_timestamp(prev_block)
        end
    end

    def test_verify_timestamp_good
        prev_data = ["5", "a38a", "Edward>Amina(1):Tang>Louis(1):SYSTEM>Cyrus(100)", "1518893687.373710000", "c675"]
        prev_block = Block::new(prev_data)

        data = ["6", "c674", "George>Edward(1):Gaozu>Anne(4):Mary>James(14):Louis>Yaa(1):SYSTEM>Louis(100)", "1518893687.380590000", "3964"]
        block = Block::new(data)

        assert_equal block.verify_timestamp(prev_block), true
    end

    def test_prev_block_timestamp_seconds
        data = ["0", "0", "SYSTEM>Henry(100)", "1.0", "c87b"]
        block = Block::new(data)

        prev_data = ["1", "0", "SYSTEM>Henry(100)", "2.0", "c87b"]
        prev_block = Block::new(prev_data)  

        assert prev_block.moreRecentThan? block
    end
end