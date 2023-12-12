require 'minitest/autorun'
require 'day_11/solution'

class Day11Test < Minitest::Test
  INPUT = %Q(
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 374, Day11.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 1030, Day11.solve_part_two(input,  10)
    assert_equal 8410, Day11.solve_part_two(input, 100)
  end
end
