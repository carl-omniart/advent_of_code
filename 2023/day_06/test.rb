require 'minitest/autorun'
require 'day_06/solution'

class Day06Test < Minitest::Test
  INPUT = %Q(
    Time:      7  15   30
    Distance:  9  40  200
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 288, Day06.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 71_503, Day06.solve_part_two(input)
  end
end
