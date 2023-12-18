require 'minitest/autorun'
require 'day_14/solution'

class Day14Test < Minitest::Test
  INPUT = %Q(
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 136, Day14.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 64, Day14.solve_part_two(input)
  end
end
