require 'minitest_helper'

class TestHaskell < MiniTest::Unit::TestCase
  def test_main
    assert_equal_execute('3') {"
      sum2 :: Integer -> Integer -> Integer
      sum2 x y = x + y
      result = sum2 1 2
    "}

    assert_equal_execute('3') {"
      sum2 :: Integer -> Integer -> Integer
      sum2 x y = x + y
      result = sum2 1 2
    "}
  end

  private
    def assert_equal_execute(str, &block)
      assert_equal str, haskell(&block)
    end
end
