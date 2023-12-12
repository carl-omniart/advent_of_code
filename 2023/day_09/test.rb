require 'minitest/autorun'
require 'day_09/solution'

class Day09Test < Minitest::Test
  INPUT = %Q(
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 114, Day09.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 2, Day09.solve_part_two(input)
  end
end
