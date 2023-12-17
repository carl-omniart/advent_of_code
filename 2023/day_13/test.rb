require 'minitest/autorun'
require 'day_13/solution'

class Day13Test < Minitest::Test
  INPUT = %Q(
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 405, Day13.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 400, Day13.solve_part_two(input)
  end
end
