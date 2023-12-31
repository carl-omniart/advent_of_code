require 'minitest/autorun'
require 'day_17/solution'

class Day17Test < Minitest::Test
  INPUT = %Q(
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 102, Day17.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 94, Day17.solve_part_two(input)
  end
end
