require 'minitest/autorun'
require 'day_07/solution'

class Day07Test < Minitest::Test
  INPUT = %Q(
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 6440, Day07.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 5905, Day07.solve_part_two(input)
  end
end
