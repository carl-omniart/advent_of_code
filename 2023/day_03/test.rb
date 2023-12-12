require 'minitest/autorun'
require 'day_03/solution'

class Day03Test < Minitest::Test
  INPUT = %Q(
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 4361, Day03.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 467_835, Day03.solve_part_two(input)
  end
end
